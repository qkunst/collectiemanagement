# frozen_string_literal: true

# == Schema Information
#
# Table name: geonames_countries
#
#  id                   :bigint           not null, primary key
#  area                 :integer
#  capital              :string
#  continent            :string
#  country              :string
#  currency_code        :string
#  currency_name        :string
#  equivalent_fips_code :string
#  fips                 :string
#  geonameid            :bigint
#  iso                  :string
#  iso3                 :string
#  iso_numeric          :string
#  languages            :string
#  neighbours           :string
#  phone                :string
#  population           :integer
#  postal_code_format   :string
#  postal_code_regex    :string
#  tld                  :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
require "rails_helper"

RSpec.describe GeonamesCountry, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
