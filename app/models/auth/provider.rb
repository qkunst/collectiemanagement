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

  def encrypted_provider_uuid
    self.class.crypt.encrypt_and_sign([uuid, DateTime.current.iso8601].join("."))
  end

  class << self
    def crypt = ActiveSupport::MessageEncryptor.new(Rails.application.credentials.secret_key_base[0..31])

    def find_by_encrypted_provider_uuid! string
      uuid, datetime_iso8601 = crypt.decrypt_and_verify(string).split(".")

      if DateTime.parse(datetime_iso8601) > 15.minutes.ago
        Provider.find_by!(uuid:)
      else
        raise OAuth2::TimeoutError.new("the provider callback id has expired")
      end
    end
  end
end
