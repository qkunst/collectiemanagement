# frozen_string_literal: true
# == Schema Information
#
# Table name: geoname_summaries
#
#  id                       :integer          not null, primary key
#  geoname_id               :integer
#  name                     :string
#  language                 :string
#  parent_description       :string
#  type_code                :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  geoname_ids              :string
#  parent_geoname_ids_cache :text
#
# Indexes
#
#  index_geoname_summaries_on_geoname_id               (geoname_id)
#  index_geoname_summaries_on_geoname_id_and_language  (geoname_id,language)
#

require "rails_helper"

RSpec.describe GeonameSummary, type: :model do
  describe "Class methods" do
    describe ".search" do
      it "should return an empty array when nil" do
        expect(GeonameSummary.search(nil)).to eq([])
        expect(GeonameSummary.search("")).to eq([])
      end
      it "should return an empty array when not found" do
        expect(GeonameSummary.search("totally weird name that never exists")).to eq([])
      end
    end
  end
end
