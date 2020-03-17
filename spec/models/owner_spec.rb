# frozen_string_literal: true

require "rails_helper"

RSpec.describe Owner, type: :model do
  describe "vaidations" do
    it "should have collection" do
      expect { Owner.create!(name: "test") }.to raise_error(ActiveRecord::RecordInvalid)
    end
    it "Should create with collection and name" do
      expect { Owner.create!(name: "test", collection: collections(:collection1)) }.not_to raise_error
    end
  end
end
