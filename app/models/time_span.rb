class TimeSpan < ApplicationRecord
  CLASSIFICATIONS = [:rental_outgoing, :rental_incoming, :transport, :exhibition, :purchase]
  SUBJECT_TYPES = ["Work"]
  STATUSSES = [:concept, :reservation, :active, :finished]

  belongs_to :collection
  belongs_to :subject, polymorphic: true
  belongs_to :contact, optional: true

  validates_presence_of :classification, inclusion: CLASSIFICATIONS.map(&:to_s), presence: true
  validates_presence_of :subject_type, inclusion: SUBJECT_TYPES, presence: true
  validates_presence_of :status, inclusion: STATUSSES.map(&:to_s), presence: true

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
    (time_spans.starts_at <= :time    AND time_spans.ends_at IS NULL)
    ", {time: Time.current})  }

  private

  def subject_available?
    errors.add(:subject, "subject not available") unless subject.available?
  end

  def remove_work_from_collection_when_purchase_active
    if status.to_s == "active" && classification.to_s == "purchase"
      subject.removed_from_collection! if subject.is_a? Work
    end
  end
end
