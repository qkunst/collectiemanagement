# frozen_string_literal: true

# == Schema Information
#
# Table name: geonames
#
#  id                :bigint           not null, primary key
#  admin1_code       :string
#  admin2_code       :string
#  admin3_code       :string
#  admin4_code       :string
#  alternatenames    :text
#  asciiname         :string
#  cc2               :string
#  country_code      :string
#  dem               :string
#  elevation         :integer
#  feature_class     :string
#  feature_code      :string
#  geonameid         :bigint
#  latitude          :float
#  longitude         :float
#  modification_date :string
#  name              :string
#  population        :integer
#  timezone          :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
require "rails_helper"

RSpec.describe Geoname, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
