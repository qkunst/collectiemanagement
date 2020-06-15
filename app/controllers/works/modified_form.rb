class Works::ModifiedForm
  include ActiveModel::Model
  include ActiveModel::AttributeAssignment

  attr_accessor :only_location_changes
  attr_accessor :only_non_qkunst

  def only_location_changes?
    truthy?(only_location_changes)
  end

  def only_non_qkunst?
    truthy?(only_non_qkunst)
  end

  private

  def truthy?(var)
    var == "1" || var == true || var == "true"
  end
end
