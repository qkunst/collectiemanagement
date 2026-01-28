# frozen_string_literal: true
# == Schema Information
#
# Table name: cached_apis
#
#  id         :integer          not null, primary key
#  query      :string
#  response   :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require "rails_helper"

RSpec.describe CachedApi, type: :model do
  describe "class methods" do
    describe ".query" do
      it "should return json" do
        fake_open_url = Rails.root.to_s + "/spec/fixtures/test_json.json"
        CachedApi.find_or_create_by({query: fake_open_url})
        expect(CachedApi.query(fake_open_url)).to eq([{"a" => 2}])
        # p geoname_summaries_url
      end
    end
  end
end
