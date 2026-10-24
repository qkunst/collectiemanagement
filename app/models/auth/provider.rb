# == Schema Information
#
# Table name: auth_providers
#
#  id         :integer          not null, primary key
#  strategy   :string
#  client_id  :string
#  secret     :string
#  options    :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  uuid       :string
#
# Indexes
#
#  index_auth_providers_on_client_id_and_strategy  (client_id,strategy)
#  index_auth_providers_on_uuid                    (uuid)
#

class Auth::Provider < ApplicationRecord
  include Uuid

  validates :strategy, :client_id, :uuid, presence: true
  validates :client_id, uniqueness: {scope: :strategy} # standard:disable Rails/UniqueValidationWithoutIndex (it exists)

  has_many :organisations, dependent: :destroy
  self.table_name = "auth_providers"
end
