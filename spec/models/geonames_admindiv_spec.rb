# frozen_string_literal: true

# == Schema Information
#
# Table name: geonames_admindivs
#
#  id         :bigint           not null, primary key
#  admin_code :string
#  admin_type :integer
#  asciiname  :string
#  geonameid  :bigint
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_geonames_admindivs_on_admin_code  (admin_code)
#
require "rails_helper"

RSpec.describe GeonamesAdmindiv, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
