require 'rails_helper'

RSpec.describe "Appraisals", type: :request do
  describe "GET /collections/1/works/1/appraisals/new" do
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
      user = users(:admin)
      sign_in user
      get new_collection_work_appraisal_path(work.collection, work)
      expect(response).to have_http_status(200)
    end
  end
end