# frozen_string_literal: true

# == Schema Information
#
# Table name: reminders
#
#  id              :bigint           not null, primary key
#  interval_length :integer
#  interval_unit   :string
#  name            :string
#  repeat          :boolean
#  text            :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  collection_id   :bigint
#  stage_id        :bigint
#
class Reminder < ApplicationRecord
  include CollectionOwnable

  INTERVAL_UNITS = {"Dagen" => :days, "Weken" => :weeks, "Maanden" => :months, "Jaren" => :years}

  belongs_to :stage, optional: true

  scope :prototypes, -> { general }
  scope :actual, -> { collection_specific }

  validates_presence_of :interval_unit, :interval_length

  has_many :messages

  def collection_stage_stage
    collection.find_state_of_stage(stage)
  end

  def reference_date
    return nil if !stage.nil? && collection_stage_stage.nil?
    stage.nil? ? created_at.to_date : collection_stage_stage.completed_at
  end

  def next_date
    next_dates.first.to_date if next_dates&.first
  end

  def last_sent_at
    last_message = messages.order(:created_at).last
    return last_message.created_at if last_message
  end

  def next_dates(amount = 10)
    if reference_date && repeat && collection
      dates = []
      time = 1
      while dates.count < 10
        date = (reference_date + additional_time(time)).to_date
        dates << date if date >= Time.now.to_date
        time += 1
      end
      dates
    elsif reference_date && collection
      date = (reference_date + additional_time(1)).to_date
      (date >= Time.now.to_date) ? [date] : []
    end
  end

  def additional_time(multiplier = 1)
    interval_length = (self.interval_length.to_i < 1) ? 1 : self.interval_length
    (interval_length * multiplier).send(interval_unit)
  end

  def to_hash
    hash = JSON.parse(to_json)
    hash["id"] = nil
    hash
  end

  def to_message!
    message = to_message
    message&.save
  end

  def current_time
    Time.now
  end

  def current_date
    current_time.to_date
  end

  def send_message_if_current_date_is_next_date!
    if (current_date == next_date) && (messages.sent_at_date(current_date).count == 0)
      to_message!
    end
  end

  def text?
    !(text.nil? || text.empty?)
  end

  def to_message
    if collection
      messages.new(
        qkunst_private: true,
        created_at: current_time,
        subject: "Herinnering: #{name}",
        message: text? ? text : "Deze herinnering heeft geen beschrijving.",
        subject_object: collection,
        from_user_name: "#{I18n.t("application.name")} Herinneringen"
      )
    end
  end

  class << self
    def send_reminders!
      Reminder.actual.all.each do |reminder|
        reminder.send_message_if_current_date_is_next_date!
      rescue NoMethodError
      end
    end
  end
end
