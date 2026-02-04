# frozen_string_literal: true

# == Schema Information
#
# Table name: geonames
#
#  id                :integer          not null, primary key
#  geonameid         :integer
#  name              :string
#  asciiname         :string
#  alternatenames    :text
#  latitude          :float
#  longitude         :float
#  feature_class     :string
#  feature_code      :string
#  country_code      :string
#  cc2               :string
#  admin1_code       :string
#  admin2_code       :string
#  admin3_code       :string
#  admin4_code       :string
#  population        :integer
#  elevation         :integer
#  dem               :string
#  timezone          :string
#  modification_date :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require "rails_helper"

RSpec.describe Geoname, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
