require_relative "../../rails_helper"

RSpec.describe Work::ParameterRerendering do
  describe "#location_raw, #location_floor_raw, #location_detail_raw" do
    it "returns not set when nil" do
      w = Work.new
      expect(w.location_raw).to eq("not_set")
      expect(w.location_floor_raw).to eq("not_set|>|not_set")
      expect(w.location_detail_raw).to eq("not_set|>|not_set|>|not_set")
    end
    it "returns values when set" do
      w = Work.new(location: "A ", location_floor: " b ", location_detail: " 1")

      expect(w.location_raw).to eq("A")
      expect(w.location_floor_raw).to eq("A|>|b")
      expect(w.location_detail_raw).to eq("A|>|b|>|1")
    end
  end
end
