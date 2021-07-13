# frozen_string_literal: true

class Works::ModifiedForm
  include ActiveModel::Model
  include ActiveModel::AttributeAssignment

  attr_accessor :only_location_changes
  attr_accessor :only_non_qkunst
  attr_reader :to_date
  attr_reader :from_date

  def to_date= value
    if value.is_a? String
      @to_date = value.present? ? value.to_date : nil
    elsif value.is_a? Date
      @to_date = value
    else
      raise "Invalid to_date value"
    end
  end

  def from_date= value
    if value.is_a? String
      @from_date = value.present? ? value.to_date : nil
    elsif value.is_a? Date
      @from_date = value
    else
      raise "Invalid from_date value"
    end
  end

  def only_location_changes?
    truthy?(only_location_changes)
  end

  def only_non_qkunst?
    truthy?(only_non_qkunst)
  end

  def active?
    only_location_changes? || only_non_qkunst? || to_date || from_date
  end

  private

  def truthy?(var)
    var == "1" || var == true || var == "true"
  end
end
