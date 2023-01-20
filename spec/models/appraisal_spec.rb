# frozen_string_literal: true

# == Schema Information
#
# Table name: appraisals
#
#  id                    :bigint           not null, primary key
#  appraised_by          :string
#  appraised_on          :date
#  appraisee_type        :string           default("Work")
#  market_value          :decimal(16, 2)
#  market_value_max      :decimal(16, 2)
#  market_value_min      :decimal(16, 2)
#  notice                :text
#  reference             :text
#  replacement_value     :decimal(16, 2)
#  replacement_value_max :decimal(16, 2)
#  replacement_value_min :decimal(16, 2)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  appraisee_id          :bigint
#  user_id               :bigint
#
# Indexes
#
#  index_appraisals_on_appraisee_id  (appraisee_id)
#
require "rails_helper"

RSpec.describe Appraisal, type: :model do
  describe "methods" do
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

    describe "#market_value_range" do
      it "should accept string" do
        expect(Appraisal.new(market_value_range: "2000..3000").market_value_range.min).to eq(2000)
      end
      it "should accept range" do
        expect(Appraisal.new(market_value_range: 2000..3000).market_value_range.min).to eq(2000)
      end
    end

    describe "#name" do
      it "should return a valid name" do
        expect(appraisals(:appraisal1).name).to eq("01-01-2000 (by test): MW €1.000,00; VW €2.000,00")
      end
      it "should also work when date is not present" do
        expect(appraisals(:appraisal_without_date).name).to eq("onbekende datum (by test): MW €1.000,00; VW €2.000,00")
      end
    end

    describe "#replacement_value_range" do
      it "should accept string" do
        expect(Appraisal.new(replacement_value_range: "2000..3000").replacement_value_range.min).to eq(2000)
      end
      it "should accept range" do
        expect(Appraisal.new(replacement_value_range: 2000..3000).replacement_value_range.min).to eq(2000)
      end
    end
  end
  describe "class" do
    describe ".new" do
      it "creates an with a once failing import hash" do
        data = {"market_value" => nil, "replacement_value" => "250.0", "appraised_on" => "2018-11-20", "market_value_max" => nil, "market_value_min" => nil, "replacement_value_min" => nil, "replacement_value_max" => nil, "appraised_by" => nil, "reference" => nil, "appraisee" => works(:work1)}
        appraisal = Appraisal.create(data)
        expect(appraisal).to be_persisted
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
