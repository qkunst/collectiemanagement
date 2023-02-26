class TimeFilter
  include ActiveModel::Model

  attr_accessor :name, :base_scope
  attr_reader :start, :end

  def start= value
    @start = value.to_date
  end

  def end= value
    @end = value.to_date
  end

  def enabled= value
    @enabled = ActiveRecord::Type::Boolean.new.deserialize(value)
  end

  def enabled
    !!(@enabled && name && (start || self.end))
  end
  alias_method :enabled?, :enabled

  def work_ids
    if enabled?
      base_scope.send(name, self.start, self.end).pluck(:id)
    end
  end
end
