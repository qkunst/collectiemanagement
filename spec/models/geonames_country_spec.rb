# frozen_string_literal: true
# == Schema Information
#
# Table name: geonames_countries
#
#  id                   :integer          not null, primary key
#  iso                  :string
#  iso3                 :string
#  iso_num              :string
#  fips                 :string
#  country_name         :string
#  capital_name         :string
#  area                 :integer
#  population           :integer
#  continent            :string
#  tld                  :string
#  currency_code        :string
#  currency_name        :string
#  phone                :string
#  postal_code_format   :string
#  postal_code_regex    :string
#  languages            :string
#  geoname_id           :integer
#  neighbours           :string
#  equivalent_fips_code :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

require "rails_helper"

RSpec.describe GeonamesCountry, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
