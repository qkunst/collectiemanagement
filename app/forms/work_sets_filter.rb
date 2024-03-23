class WorkSetsFilter
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :deactivated, :boolean

  alias_method :deactivated?, :deactivated
end
