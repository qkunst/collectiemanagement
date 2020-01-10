# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaperTrail::Version, type: :model do
  context "Work" do
    it "should reify and return artist_name_rendered of that time" do
      expect(works(:work2).versions.first.reify.artist_name_rendered).to eq("Kwastenman, Kees de")
      expect(works(:work2).versions.first.reify.stock_number).to eq(works(:work2).stock_number)
    end
  end
end
