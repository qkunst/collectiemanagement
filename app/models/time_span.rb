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
# Indexes
#
#  index_time_spans_on_subject_type_and_subject_id  (subject_type,subject_id)
#  index_time_spans_on_uuid                         (uuid)
#
class TimeSpan < ApplicationRecord
  include Uuid

  store :old_data, coder: JSON
  has_paper_trail

  CLASSIFICATIONS = [:rental_outgoing, :transport, :exhibition, :purchase] # :rental_incoming was part of this as well, but
  SUBJECT_TYPES = ["Work", "WorkSet"]
  STATUSSES = [:concept, :reservation, :active, :finished]

  belongs_to :collection
  belongs_to :subject, polymorphic: true
  belongs_to :contact, optional: true
  belongs_to :time_span, optional: true

  has_many :time_spans

  validates :classification, inclusion: CLASSIFICATIONS.map(&:to_s), presence: true
  validates :subject_type, inclusion: SUBJECT_TYPES, presence: true
  validates :status, inclusion: STATUSSES.map(&:to_s), presence: true
  validates :starts_at, presence: true

  validate :validate_subject_available?

  before_save :significantly_update_works!
  after_save :remove_work_from_collection_when_purchase_active
  after_save :sync_time_spans_for_works_when_work_set

  # status-scopes
  scope :status, ->(status) { where(status: status) }
  scope :concept, -> { status(:concept) }
  scope :reservation, -> { status(:reservation) }
  scope :active, -> { status(:active) }
  scope :finished, -> { status(:finished) }
  scope :active_or_finished, -> { status([:active, :finished]) }

  # classification-scopes
  scope :classification, ->(classification) { where(classification: classification) }
  scope :rental_outgoing, -> { classification(:rental_outgoing) }

  scope :subject_type, ->(subject_type) do
    if SUBJECT_TYPES.include?(subject_type)
      where(subject_type: subject_type)
    else
      raise("unsupported subject type")
    end
  end

  scope :expired, -> { current.where("time_spans.ends_at <= ?", Time.current) }
  scope :period, ->(period) {
                   where("
    (time_spans.starts_at <= :start AND time_spans.ends_at >= :start) OR
    (time_spans.starts_at <= :start AND time_spans.ends_at IS NULL) OR
    (time_spans.starts_at > :start AND time_spans.starts_at < :end) OR
    (time_spans.starts_at <= :start AND time_spans.status = 'active')
    ", {start: period.begin || 2000.years.ago, end: period.end || 2000.years.from_now})
                 }
  scope :current, -> { period(Time.now...Time.now) }
  scope :sold, -> { where(status: [:active, :finished]).where(classification: :purchase) }
  scope :sold_within_period, ->(period) { sold.where(starts_at: period) }
  scope :outgoing_rental_within_period, ->(period) { period(period).rental_outgoing.active_or_finished }

  def contact_url
    contact&.url
  end

  def rental_outgoing?
    classification&.to_sym == :rental_outgoing
  end

  def purchase?
    classification&.to_sym == :purchase
  end

  def purchase_or_rental_outgoing?
    purchase? || rental_outgoing?
  end
  alias_method :at_customer?, :purchase_or_rental_outgoing?

  def finish
    self.ends_at ||= Time.current
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

  # try to finish historic imported TimeSpans
  def refinish
    if ends_at.nil?
      self.ends_at = next_time_span&.starts_at
    end
    if ends_at.nil? && starts_at < 5.years.ago
      self.ends_at = starts_at
      self.comments = "Finished old time span; assuming error"
    end
  end

  def refinish!
    refinish
    save
  end

  # next TimeSpan
  # @return TimeSpan
  def next_time_span
    time_spans = subject.time_spans.order(:starts_at).to_a
    next_index = time_spans.index(self) + 1
    time_spans[next_index]
  end

  def current?
    current_time = Time.current

    (starts_at.nil? && ends_at.nil?) or
      (starts_at.nil? && ends_at > current_time) or
      (ends_at.nil? && starts_at <= current_time) or
      (starts_at <= current_time && ends_at > current_time) or
      (starts_at <= current_time && status == "active")
  end

  def status= new_status
    if new_status.to_s == "finished"
      finish
    else
      write_attribute(:status, new_status)
    end
  end

  def contact= new_contact
    new_contact_obj = if new_contact.nil?
      nil
    elsif new_contact.is_a?(Contact)
      new_contact
    elsif new_contact.present? && new_contact.to_i.to_s == new_contact
      Contact.find(new_contact)
    elsif new_contact.start_with?("https://", "http://")
      Contact.find_or_create_by(url: new_contact, collection: collection.base_collection, external: true)
    end

    if new_contact_obj
      self.contact_id = new_contact_obj.id
    elsif new_contact.nil?
      self.contact_id = nil
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

  def humanize_starts_at_ends_at
    [starts_at, ends_at].compact.map { |d| I18n.l(d.to_date, format: :short) }
  end

  def humanize_status
    I18n.t(status, scope: "activerecord.values.time_span.status")
  end

  def humanize_classification
    I18n.t(classification, scope: "activerecord.values.time_span.classification")
  end

  def humanize_subject
    (subject.is_a?(Work) ? subject.stock_number : subject.name)
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

  def name
    [
      humanize_status.upcase,
      humanize_classification,
      humanize_starts_at_ends_at,
      humanize_subject,
      contact&.name
    ].compact.join(" ")
  end

  def works
    if subject.is_a?(WorkSet)
      subject.works
    elsif subject.is_a?(Work)
      [subject]
    end
  end

  def to_s
    "#{starts_at}-#{ends_at} #{status} #{subject.is_a?(Work) ? subject.stock_number : subject.to_s} #{contact}"
  end

  def similar_child_time_spans
    TimeSpan.where(classification: classification, contact_id: contact_id, collection: collection, time_span_id: id)
  end

  private

  def subject_available?
    subject&.available?
  end

  def self_is_subject_current_active_time_span?
    subject && (subject.current_active_time_span && subject.current_active_time_span.id == id)
  end

  def subject_is_at_customer?
    subject_time_span = subject&.current_active_time_span

    subject_time_span&.active? && subject_time_span&.at_customer?
  end

  def to_be_at_customer?
    at_customer?
  end

  def validate_subject_available?
    if subject_available? || reservation? || finished? || self_is_subject_current_active_time_span?
      # is ok
    elsif active? && to_be_at_customer? && !subject_is_at_customer?
      # also ok
    elsif !subject_available? && !finished? && !reservation? && !self_is_subject_current_active_time_span?
      errors.add(:subject, "subject not available")
    end
  end

  def remove_work_from_collection_when_purchase_active
    if active? && purchase?
      subject.removed_from_collection!(starts_at || Time.current) if subject.is_a? Work
    end
  end

  def sync_time_spans_for_works_when_work_set
    if subject.is_a?(WorkSet)
      subject.works.each do |work|
        ts = similar_child_time_spans.find_by(subject: work)
        if ts.nil? && work.available?
          ts = similar_child_time_spans.new(subject: work, time_span: self)
        end

        if ts && !ts.finished?
          ts.starts_at ||= created_recently? ? starts_at : Time.current
          ts.status = status
          ts.ends_at = ends_at unless ts.ends_at && ts.ends_at < Time.current
        end

        ts&.save
      end

      time_spans.each do |ts|
        if ts.subject.is_a?(Work) && !subject.works.include?(ts.subject)
          ts.update(time_span: nil)
        elsif !ts.finished?
          ts.ends_at = ends_at unless ts.ends_at && ts.ends_at < Time.current
          ts.status = status
          ts.contact = contact
          ts.starts_at ||= created_recently? ? starts_at : Time.current
          ts.save
        end
      end
    end
  end

  def significantly_update_works!
    subject.significantly_updated!
  end

  def created_recently?
    created_at > 5.minutes.ago
  end
end
