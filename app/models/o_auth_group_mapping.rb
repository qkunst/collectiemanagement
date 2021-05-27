# t.string "issuer"
# t.string "value_type"
# t.string "value"
# t.string "collection_id"
# t.string "role"

class OAuthGroupMapping < ApplicationRecord
  has_paper_trail

  validates_inclusion_of :value_type, in: %w[role group], allow_blank: false
  validates_presence_of :issuer
  validates_presence_of :value
  validates_inclusion_of :role, in: User::ROLES, allow_blank: true

  belongs_to :collection, optional: true

  class << self
    def collection_mappings_exists_for?(issuer)
      where(issuer: issuer).where.not(collection_id: nil).any?
    end

    def role_mappings_exists_for?(issuer)
      where(issuer: issuer).where.not(role: nil).any?
    end

    def for(data)
      where(value_type: :role, value: data.roles, issuer: data.issuer).or(where(value_type: :group, value: data.groups, issuer: data.issuer))
    end

    def retrieve_roles(data)
      self.for(data).pluck(:role).compact.uniq.map(&:to_sym)
    end

    def retrieve_collection_ids(data)
      self.for(data).pluck(:collection_id).compact.uniq
    end
  end
end
