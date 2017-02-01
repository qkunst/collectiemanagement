class Reminder < ApplicationRecord
  INTERVAL_UNITS = {"Dagen"=>:days, "Weken"=>:weeks, "Maanden"=>:months, "Jaren"=>:years}

  belongs_to :stage
  belongs_to :collection

  scope :prototypes, ->{ where(collection_id: nil)}

  validates_presence_of :interval_unit, :interval_length

  def collection_stage_stage
    collection.find_state_of_stage(stage)
  end

  def reference_date
    stage.nil? ? created_at.to_date : collection_stage_stage.completed_at
  end

  def next_date
    next_dates.first if next_dates
  end

  def next_dates(amount=10)
    if reference_date and repeat and collection
      dates = []
      time = 1
      while dates.count < 10
        date = (reference_date + additional_time(time)).to_date
        dates << date if date > Time.now.to_date
        time += 1
      end
      return dates
    elsif reference_date and collection
      date = (reference_date + additional_time(1)).to_date
      return (date > Time.now.to_date) ? [date] : []
    end
  end

  def additional_time(multiplier = 1)
    interval_length = (self.interval_length.to_i < 1) ? 1 : self.interval_length
    (interval_length * multiplier).send(interval_unit)
  end

  def to_hash
    hash = JSON.parse(to_json)
    hash['id'] = nil
    hash
  end
end
