# frozen_string_literal: true

require "rails_helper"

RSpec.describe "WorkBatchs", type: :request do
  describe "GET /collections/:id/batch/" do
    describe "Collection defense" do
      it "shouldn't be publicly accessible!" do
        collection = collections(:collection1)
        get collection_batch_path(collection)
        expect(response).to have_http_status(302)
      end
      it "should be accessible when logged in as admin" do
        user = users(:admin)
        collection = collections(:collection1)
        sign_in user
        get collection_batch_path(collection)
        expect(response).to have_http_status(200)
      end
      it "should not be accessible when logged in as an anonymous user" do
        sign_in users(:user_with_no_rights)
        get collection_batch_path(collections(:collection1))
        expect(response).to have_http_status(302)
        expect(response).to redirect_to root_path
      end
      it "should not be accessible when logged in as an registrator user" do
        sign_in users(:qkunst)
        get collection_batch_path(collections(:collection1))
        expect(response).to have_http_status(302)
        expect(response).to redirect_to root_path
      end
      it "should not allow accesss to the batch editor for non qkunst user has access to" do
        user = users(:read_only_user)
        sign_in user
        collection = collections(:collection3)
        get collection_batch_path(collection)
        expect(response).to have_http_status(302)
      end

      it "should redirect to the root when accessing anohter collection" do
        user = users(:read_only_user)
        sign_in user
        collection = collections(:collection1)
        get collection_batch_path(collection)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to root_path
      end
    end
    describe "Field-accessibility" do
      it "describe facility should only be able to edit location" do
        sign_in users(:facility_manager)
        get collection_batch_path(collections(:collection1))
        response_body = response.body
        expect(response_body).to match('Adres en\/of gebouw\(deel\)\<\/label\>')
        expect(response_body).not_to match('Overige opmerkingen<\/label>')
        expect(response_body).not_to match('Aankoopprijs<\/label>')
        expect(response_body).not_to match('Marktwaardecategorie \(€\)<\/label>')
        expect(response_body).not_to match('Overige opmerkingen<\/label>')
      end
      it "describe facility should only be able to edit location" do
        sign_in users(:appraiser)
        get collection_batch_path(collections(:collection1))
        response_body = response.body
        expect(response_body).to match('Waardering door')
        expect(response_body).to match('Adres en\/of gebouw\(deel\)\<\/label\>')
        expect(response_body).to match('Overige opmerkingen<\/label>')
        expect(response_body).to match('Aankoopprijs<\/label>')
        expect(response_body).to match('Marktwaardecategorie \(€\)<\/label>')
        expect(response_body).to match('Overige opmerkingen<\/label>')
      end
    end
  end
  describe "PATCH /collection/:collection_id/batch" do
    describe "process appraisal ignore" do
      it "should store appraisal" do
        sign_in users(:appraiser)
        appraisal_date = "2012-07-21".to_date
        patch collection_batch_path(collections(:collection1)), params: {work_ids_comma_separated: works(:work1).id, work: {appraisals_attributes: {"0": {appraised_on: appraisal_date, update_appraised_on_strategy: "REPLACE", market_value: 2_000, update_market_value_strategy: "REPLACE", reference: "abc", update_reference_strategy: "REPLACE"}}}}
        appraisal = Appraisal.find_by(appraised_on: appraisal_date)
        expect(appraisal.appraised_on).to eq(appraisal_date)
        expect(appraisal.market_value).to eq(2_000)
        expect(appraisal.reference).to eq("abc")
      end
      it "should ignore ignored fields" do
        sign_in users(:appraiser)
        appraisal_date = Time.now.to_date
        patch collection_batch_path(collections(:collection1)), params: {work_ids_comma_separated: works(:work1).id, work: {appraisals_attributes: {"0": {appraised_on: appraisal_date, update_appraised_on_strategy: "REPLACE", appraised_by: "Harald", update_appraised_by_strategy: "REPLACE", market_value: 2_000, update_market_value_strategy: "REPLACE", reference: "abc", update_reference_strategy: "IGNORE"}}}}
        appraisal = Appraisal.find_by(appraised_on: appraisal_date)
        expect(appraisal.appraised_on).to eq(appraisal_date)
        expect(appraisal.market_value).to eq(2_000)
        expect(appraisal.appraised_by).to eq("Harald")
        expect(appraisal.reference).to eq(nil)
      end
    end
    describe "themes" do
      it "appends themes" do
        sign_in users(:admin)
        collection = collections(:collection1)
        works = [works(:work1), works(:work2)]
        theme = themes(:fire)

        patch collection_batch_path(collection), params: {work_ids_comma_separated: works.map(&:id).join(","), work: {collection_id: collection.id, theme_ids: ["", theme.id], update_theme_ids_strategy: "APPEND"}}
        expect(response).to have_http_status(302)

        works.each do |work|
          work = Work.find(work.id)
          expect(work.themes).to include(theme)
        end
      end
    end
    describe "tag_list" do
      it "should REPLACE" do
        sign_in users(:admin)
        collection = collections(:collection1)
        works = [works(:work1), works(:work2)]
        works.collect { |a| a.tag_list = ["existing_tag"]; a.save }
        patch collection_batch_path(collection), params: {work_ids_comma_separated: works.map(&:id).join(","), work: {collection_id: collection.id, tag_list: ["eerste nieuwe tag", "first new tag"], update_tag_list_strategy: "REPLACE"}}
        expect(response).to have_http_status(302)
        works.collect { |a| a.reload }
        expect(works.first.tag_list).to match_array(["eerste nieuwe tag", "first new tag"])
      end
      it "should APPEND" do
        sign_in users(:admin)
        collection = collections(:collection1)
        works = [works(:work1), works(:work2)]
        works.collect { |a| a.tag_list = ["existing_tag"]; a.save }
        patch collection_batch_path(collection), params: {work_ids_comma_separated: works.map(&:id).join(","), work: {collection_id: collection.id, tag_list: ["eerste nieuwe tag", "first new tag"], update_tag_list_strategy: "APPEND"}}
        expect(response).to have_http_status(302)
        works.collect { |a| a.reload }
        expect(works.first.tag_list).to match_array(["existing_tag", "eerste nieuwe tag", "first new tag"])
      end
      it "should REMOVE" do
        sign_in users(:admin)
        collection = collections(:collection1)
        works = [works(:work1), works(:work2)]
        works.collect { |a| a.tag_list = ["existing_tag", "tag to delete"]; a.save }
        patch collection_batch_path(collection), params: {work_ids_comma_separated: works.map(&:id).join(","), work: {collection_id: collection.id, tag_list: ["tag to delete", "eerste nieuwe tag", "first new tag"], update_tag_list_strategy: "REMOVE"}}
        expect(response).to have_http_status(302)
        works.collect { |a| a.reload }
        expect(works.first.tag_list).to match_array(["existing_tag"])
      end
    end
  end
end
