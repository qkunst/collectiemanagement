require 'rails_helper'

RSpec.describe Appraisal, type: :model do
  describe "methods" do
    describe "#name" do
      it "should return a valid name" do
        expect(appraisals(:appraisal1).name).to eq("01-01-2000 (by test): MW €1.000,00; VW €2.000,00")
      end
    end
  end
end
