# frozen_string_literal: true

require "rails_helper"

RSpec.describe WorksHelper, type: :helper do
  describe "filter_checkbox" do
    it "should return an nothing when empty" do
      # expect(helper.filter_checkbox("field_name0","value0")).to eq("")
    end
  end

  describe "translate_extended_count" do
    it "should return no works count" do
      expect(helper.translate_extended_count([])).to eq("geen werken")
    end

    it "should return works count" do
      expect(helper.translate_extended_count([1])).to eq("1 werk")
      expect(helper.translate_extended_count([1, 1])).to eq("2 werken")
    end

    it "should return parts if different" do
      expect(helper.translate_extended_count(Work.where("stock_number LIKE 'QDT2a-%'"))).to eq("1 werk (2 onderdelen)")
    end
  end
end
