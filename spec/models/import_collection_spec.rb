# frozen_string_literal: true

require "rails_helper"

RSpec.describe ImportCollection, type: :model do
  describe "instance methods" do
    describe "#name" do
      it "should return a name even when no file has been uploaded" do
        i = ImportCollection.new
        expect(i.name).to eq("Geen bestand geüpload")
      end
    end
  end
end
