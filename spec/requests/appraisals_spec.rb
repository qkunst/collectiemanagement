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

  describe "POST appraisals (#create)" do
    let(:params) { {appraisal: {appraised_by: "Someone", appraised_on: "2020-05-26", appraisee_attributes: {purchase_price: 123, purchase_price_currency_id: currencies(:nlg).id, print_unknown: false, main_collection: false, grade_within_collection: "C"}}} }
    let(:appraisee) { works(:work1) }
    let(:create_appraisal) { post collection_work_appraisals_path(appraisee.collection, appraisee), params: params }
    let(:user) { users(:admin) }

    before do
      sign_in user
    end

    describe "POST /collections/1/works/1/appraisals" do
      it "stores an appraisal" do
        expect {
          create_appraisal
        }.to change(Appraisal, :count).by(1)

        appraisee.reload
        expect(appraisee.purchase_price).to eq(123)
      end
    end

    describe "POST /collections/:collection_id/work_sets/:work_set_id/appraisals" do
      let(:user) { users(:appraiser) } # collection1, collection3
      let(:appraisee) { work_sets(:work_diptych) } # by default all in collection3
      let(:create_appraisal) { post collection_work_set_appraisals_path(collections(:collection3), appraisee), params: params }
      it "allows for appraising" do
        expect {
          create_appraisal
        }.to change(Appraisal, :count).by(1)
      end
      describe "single work not in accessible collection" do
        before do
          appraisee.works << works(:work7)
        end
        it "does not allow appraising a work set that is partially not accessible" do
          expect {
            create_appraisal
          }.to change(Appraisal, :count).by(0)
        end
      end
    end
  end
end
