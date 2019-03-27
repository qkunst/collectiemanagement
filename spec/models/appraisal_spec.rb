# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Appraisal, type: :model do
  describe "methods" do
    describe "#name" do
      it "should return a valid name" do
        expect(appraisals(:appraisal1).name).to eq("01-01-2000 (by test): MW €1.000,00; VW €2.000,00")
      end
      it "should also work when date is not present" do
        expect(appraisals(:appraisal_without_date).name).to eq("onbekende datum (by test): MW €1.000,00; VW €2.000,00")
      end
    end
    describe "#destroy" do
      it "should be destroyable" do
        work = works(:work1)
        work.update_latest_appraisal_data!
        work.reload
        expect(work.market_value).to eq(4000)
        appraisals(:appraisal2).destroy
        work.reload
        expect(work.market_value).to eq(4000)
        appraisals(:appraisal4).destroy
        work.reload
        expect(work.market_value).to eq(3000)
        appraisals(:appraisal3).destroy
        work.reload
        expect(work.market_value).to eq(1000)
        appraisals(:appraisal1).destroy
        work.reload

        appraisals(:appraisal_without_date).destroy
      end
    end
  end
  describe "scopes" do
    describe ".descending_appraisal_on" do
      it "should return the latest by date and then id" do
        expect(Appraisal.descending_appraisal_on.first.market_value).to eq(4000)
      end
    end
  end
end
