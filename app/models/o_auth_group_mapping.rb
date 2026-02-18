# == Schema Information
#
# Table name: o_auth_group_mappings
#
#  id            :integer          not null, primary key
#  issuer        :string
#  value_type    :string
#  value         :string
#  collection_id :integer
#  role          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class OAuthGroupMapping < ApplicationRecord
  has_paper_trail

  validates :value_type, inclusion: {in: %w[role group resource], allow_blank: false}
  validates :issuer, presence: true
  validates :value, presence: true
  validates :role, inclusion: {in: User::ROLES.map(&:to_s), allow_blank: true}

  belongs_to :collection, optional: true

  class << self
    def collection_mappings_exists_for?(issuer)
      where(issuer: issuer).where.not(collection_id: nil).any?
    end

    def role_mappings_exists_for?(issuer)
      where(issuer: issuer).where.not(role: nil).any?
    end

    def for(data)
      where(value_type: :role, value: data.roles, issuer: data.issuer).or(where(value_type: :group, value: data.groups, issuer: data.issuer)).or(where(value_type: :resource, value: data.resources, issuer: data.issuer))
    end

    def retrieve_roles(data)
      self.for(data).pluck(:role).compact.uniq.map(&:to_sym)
    end

    def retrieve_collection_ids(data)
      self.for(data).pluck(:collection_id).compact.uniq
    end
  end
end
