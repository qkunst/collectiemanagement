class TimeFilter
  include ActiveModel::Model

  attr_accessor :enabled, :name
  attr_reader :start, :end

  def start= value
    @start = value.to_date
  end

  def end= value
    @end = value.to_date
  end

  def enabled?
    ActiveRecord::Type::Boolean.new.deserialize(@enabled)
  end
end
