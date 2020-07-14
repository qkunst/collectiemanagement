# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Appraisals", type: :request do

  describe "GET /collections/1/works/1/appraisals/new" do
    describe "HTTP response codes" do
      it "it refuses by default" do
        work = works(:work1)
        get new_collection_work_appraisal_path(work.collection, work)
        expect(response).to have_http_status(302)
      end
      it "it refuses by qkunst" do
        work = works(:work1)
        user = users(:qkunst)
        sign_in user
        get new_collection_work_appraisal_path(work.collection, work)
        expect(response).to have_http_status(302)
      end
      it "it works for admin" do
        work = works(:work1)
        sign_in users(:admin)
        get new_collection_work_appraisal_path(work.collection, work)
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "GET /collections/1/works/1/appraisals/1/edit" do
    it "refuses by default" do
      work = works(:work1)
      get edit_collection_work_appraisal_path(work.collection, work, appraisals(:appraisal4))
      expect(response).to have_http_status(302)
    end
    it "refuses by qkunst" do
      work = works(:work1)
      user = users(:qkunst)
      sign_in user
      get edit_collection_work_appraisal_path(work.collection, work, appraisals(:appraisal4))
      expect(response).to have_http_status(302)
    end
    context :admin do
      before do
        user = users(:admin)
        sign_in user
      end

      it "works for admin" do
        appraisal = appraisals(:appraisal4)

        get edit_collection_work_appraisal_path(appraisal.work.collection, appraisal.work, appraisal)
        expect(response).to have_http_status(200)
      end
      it "allows editing ranges" do
        appraisal = appraisals(:appraisal_with_existing_range)
        get edit_collection_work_appraisal_path(appraisal.work.collection, appraisal.work, appraisal)
        expect(response).to have_http_status(200)
      end

      it "allows editing non-existing ranges" do
        appraisal = appraisals(:appraisal_with_non_existing_range)
        get edit_collection_work_appraisal_path(appraisal.work.collection, appraisal.work, appraisal)
        expect(response).to have_http_status(200)
      end
    end


  end

  describe "POST /collections/1/works/1/appraisals" do
    it "stores an appraisal" do
      user = users(:admin)
      sign_in user

      work = works(:work1)

      # params.require(:appraisal).permit(:appraised_on, :market_value, :replacement_value, :market_value_range, :replacement_value_range, :appraised_by, :reference, work_attributes: [
#         :id, :purchased_on, :purchase_year, :purchase_price, :purchase_price_currency_id, :print, :print_unknown, :source_comments,
#         :grade_within_collection, :main_collection, :owner_id, :other_comments, source_ids: []
#       ])
#

      # "appraisal"=>{"appraised_by"=>"Maartje de Roy van Zuydewijn", "appraised_on"=>"2020-05-26", "market_value"=>"", "replacement_value"=>"", "reference"=>"", "work_attributes"=>{"purchased_on"=>"", "purchase_year"=>"", "purchase_price"=>"2578", "purchase_price_currency_id"=>"3", "source_ids"=>[""], "source_comments"=>"", "grade_within_collection"=>"C", "main_collection"=>"0", "owner_id"=>"", "print"=>"", "print_unknown"=>"0", "other_comments"=>"", "id"=>"1647"}

      expect {
        post collection_work_appraisals_path(work.collection, work), params: {appraisal: {appraised_by: "Someone", appraised_on: "2020-05-26", work_attributes: {purchase_price: 123, purchase_price_currency_id: currencies(:nlg).id, print_unknown: false, main_collection: false, grade_within_collection: "C"}}}
      }.to change(Appraisal, :count).by(1)

      work.reload
      expect(work.purchase_price).to eq(123)
    end
  end
end
