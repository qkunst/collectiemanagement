# == Schema Information
#
# Table name: organisations
#
#  id               :integer          not null, primary key
#  domains          :json
#  auth_provider_id :integer
#  name             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_organisations_on_auth_provider_id  (auth_provider_id)
#

class Organisation < ApplicationRecord
  belongs_to :auth_provider, optional: true
end
