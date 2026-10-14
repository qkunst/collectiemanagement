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

require 'rails_helper'

RSpec.describe Organisation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
