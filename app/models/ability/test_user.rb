class Ability::TestUser
  def initialize(role)
    @role = role
  end

  attr_reader :role

  def accessible_collections
    []
  end

  def accessible_collection_ids
    []
  end

  def admin?
    @role == :admin
  end

  def advisor?
    @role == :advisor
  end

  def compliance?
    @role == :compliance
  end

  def appraiser?
    @role == :appraiser
  end

  def registrator?
    @role == :qkunst || @role == :registrator
  end

  def facility_manager?
    @role == :facility_manager
  end

  def read_only?
    @role == :read_only
  end

  def role_manager?
    @role == :role_manager
  end
end
