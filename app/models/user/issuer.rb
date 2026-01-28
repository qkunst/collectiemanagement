class User::Issuer
  attr_reader :issuer
  # issuer is a string comprised of the provider and the issuer field in the open id response
  # this issuer name is also used in the oauth group/role collection/role mapping
  def initialize(issuer)
    @issuer = issuer
  end

  def oauth_group_mappings
    OAuthGroupMapping.where(issuer:)
  end

  def role_mappings
    oauth_group_mappings.where.not(role: nil)
  end

  def collection_mappings
    oauth_group_mappings.where.not(collection_id: nil)
  end

  def role_mappings?
    role_mappings.any?
  end

  def collection_mappings?
    collection_mappings.any?
  end
end
