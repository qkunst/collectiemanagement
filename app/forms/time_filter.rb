class TimeFilter
  include ActiveModel::Model

  attr_accessor :name
  attr_reader :enabled, :start, :end
  alias_method :enabled?, :enabled

  def start= value
    @start = value.to_date
  end

  def end= value
    @end = value.to_date
  end

  def enabled= value
    @enabled = ActiveRecord::Type::Boolean.new.deserialize(value)
  end
end
