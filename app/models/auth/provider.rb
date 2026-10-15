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
#

class Auth::Provider < ApplicationRecord
  has_many :organisations, dependent: :destroy
  self.table_name = "auth_providers"
end
