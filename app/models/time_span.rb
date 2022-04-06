class TimeSpan < ApplicationRecord
  include Uuid

  CLASSIFICATIONS = [:rental_outgoing, :rental_incoming, :transport, :exhibition, :purchase]
  SUBJECT_TYPES = ["Work"]
  STATUSSES = [:concept, :reservation, :active, :finished]

  belongs_to :collection
  belongs_to :subject, polymorphic: true
  belongs_to :contact, optional: true

  validates :classification, inclusion: CLASSIFICATIONS.map(&:to_s), presence: true
  validates :subject_type, inclusion: SUBJECT_TYPES, presence: true
  validates :status, inclusion: STATUSSES.map(&:to_s), presence: true

  validate :subject_available?

  after_save :remove_work_from_collection_when_purchase_active

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
    self.status = :finished
  end

  def current?
    current_time = Time.current
    return (
      (starts_at.nil?            && ends_at.nil?) or
      (starts_at.nil?            && ends_at >= current_time) or
      (ends_at.nil?              && starts_at <= current_time) or
      (starts_at <= current_time && ends_at >= current_time) or
      (starts_at <= current_time && status == 'active')
    )
  end

  def active?
    status.to_s == "active"
  end

  def current_and_active?
    active? && current?
  end

  def to_s
    "#{starts_at}-#{ends_at} #{status} #{subject.is_a?(Work) ? subject.stock_number : subject.to_s} #{contact}"
  end

  private

  def subject_available?
    errors.add(:subject, "subject not available") if subject && !subject.available? && status != "finished"
  end

  def remove_work_from_collection_when_purchase_active
    if status.to_s == "active" && classification.to_s == "purchase"
      subject.removed_from_collection!(starts_at) if subject.is_a? Work
    end
  end
end
