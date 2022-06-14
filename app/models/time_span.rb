# == Schema Information
#
# Table name: time_spans
#
#  id             :bigint           not null, primary key
#  classification :string
#  comments       :text
#  ends_at        :datetime
#  old_data       :text
#  starts_at      :datetime
#  status         :string
#  subject_type   :string
#  uuid           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  collection_id  :bigint
#  contact_id     :bigint
#  subject_id     :bigint
#  time_span_id   :bigint
#
class TimeSpan < ApplicationRecord
  include Uuid

  store :old_data, coder: JSON
  has_paper_trail

  CLASSIFICATIONS = [:rental_outgoing, :transport, :exhibition, :purchase] #:rental_incoming was part of this as well, but
  SUBJECT_TYPES = ["Work", "WorkSet"]
  STATUSSES = [:concept, :reservation, :active, :finished]

  belongs_to :collection
  belongs_to :subject, polymorphic: true, touch: true
  belongs_to :contact, optional: true
  belongs_to :time_span, optional: true

  has_many :time_spans

  validates :classification, inclusion: CLASSIFICATIONS.map(&:to_s), presence: true
  validates :subject_type, inclusion: SUBJECT_TYPES, presence: true
  validates :status, inclusion: STATUSSES.map(&:to_s), presence: true
  validates :starts_at, presence: true

  validate :validate_subject_available?

  after_save :remove_work_from_collection_when_purchase_active
  after_save :sync_time_spans_for_works_when_work_set

  # status-scopes
  scope :concept, ->{ where(status: :concept) }
  scope :reservation, ->{ where(status: :reservation) }
  scope :active, ->{ where(status: :active) }
  scope :finished, ->{ where(status: :finished) }

  # classification-scopes
  scope :rental_outgoing, ->{ where(classification: :rental_outgoing) }

  # time-scopes
  scope :current, ->{ where("
    (time_spans.starts_at IS NULL AND time_spans.ends_at IS NULL) OR
    (time_spans.starts_at <= :time    AND time_spans.ends_at >= :time) OR
    (time_spans.starts_at IS NULL AND time_spans.ends_at >= :time) OR
    (time_spans.starts_at <= :time    AND time_spans.ends_at IS NULL) OR
    (time_spans.starts_at <= :time    AND time_spans.status = 'active')

    ", {time: Time.current})  }

  scope :expired, ->{ current.where("time_spans.ends_at <= ?", Time.current) }

  def contact_url
    contact&.url
  end

  def finish
    self.ends_at = Time.current
    write_attribute(:status, :finished)
  end

  def end_time_span
    self.ends_at = Time.current
    finish if active?
  end

  def end_time_span!
    end_time_span
    save
  end

  def current?
    current_time = Time.current
    return (
      (starts_at.nil?            && ends_at.nil?) or
      (starts_at.nil?            && ends_at > current_time) or
      (ends_at.nil?              && starts_at <= current_time) or
      (starts_at <= current_time && ends_at > current_time) or
      (starts_at <= current_time && status == 'active')
    )
  end

  def status= new_status
    if new_status.to_s == "finished"
      finish
    else
      write_attribute(:status, new_status)
    end
  end

  def contact= new_contact
    new_contact_obj = if new_contact.is_a?(Contact)
      new_contact
    elsif new_contact.present? && new_contact.to_i.to_s == new_contact
      Contact.find(new_contact)
    elsif new_contact.start_with?("https://") || new_contact.start_with?("http://")
      Contact.find_or_create_by(url: new_contact, collection: self.collection.base_collection, external: true)
    end

    if new_contact_obj
      self.contact_id = new_contact_obj.id
    end
  end

  def active?
    status.to_s == "active"
  end

  def current_and_active?
    active? && current?
  end

  def current_and_active_or_reserved?
    (active? || reserved?) && current?
  end

  def concept?
    status.to_s == "concept"
  end

  def reserved?
    status.to_s == "reservation"
  end
  alias_method :reservation?, :reserved?

  def finished?
    status.to_s == "finished"
  end

  def to_s
    "#{starts_at}-#{ends_at} #{status} #{subject.is_a?(Work) ? subject.stock_number : subject.to_s} #{contact}"
  end

  private

  def subject_available?
    subject && subject.available?
  end

  def self_is_subject_current_active_time_span?
    subject && (self.id && subject.current_active_time_span&.id == self.id)
  end

  def validate_subject_available?
    errors.add(:subject, "subject not available") if !subject_available? && !finished? && !reservation? && !self_is_subject_current_active_time_span?
  end

  def remove_work_from_collection_when_purchase_active
    if status.to_s == "active" && classification.to_s == "purchase"
      subject.removed_from_collection!(starts_at || Time.current) if subject.is_a? Work
    end
  end

  def sync_time_spans_for_works_when_work_set
    if subject.is_a?(WorkSet)
      subject.works.each do |work|
        ts = TimeSpan.find_or_initialize_by(time_span_id: self.id, classification: classification, contact_id: contact_id, subject: work, starts_at: starts_at, collection: collection)

        unless ts.finished?
          ts.starts_at ||= starts_at
          ts.status = status
          ts.ends_at ||= ends_at
        end

        ts.save
      end
    end
  end
end
