# frozen_string_literal: true

require "rails_helper"

RSpec.describe WorksController, type: :controller do
  let(:collection) { collections(:collection_with_works) }

  include Devise::Test::ControllerHelpers

  render_views

  describe "GET /collections/:collection_id/works (#index)" do
    context "not signed in" do
      it "it is inaccessible by users who are not signed in" do
        expect(get(:index, params: {collection_id: collection.id})).to redirect_to new_user_session_path
      end
    end

    context "advisor" do
      before do
        sign_in users(:advisor)
      end

      it "renders pdf titles" do
        get(:index, params: {collection_id: collection.id})
        expect(response.body).to match(/works\.pdf\?as=title_labels&amp;foreground_color=000000&amp;resource_variant=public&amp;show_logo=true/)
        expect(response.body).to match(/works\.pdf\?as=title_labels&amp;foreground_color=000000&amp;qr_code_enabled=true&amp;resource_variant=public&amp;show_logo=true/)
      end

      it "renders pdf titles" do
        collection.update(pdf_title_export_variants_text: "Een bijzondere klantwens:\n  show_logo: false\n  foreground_color: \"ffff00\"")

        get(:index, params: {collection_id: collection.id})
        expect(response.body).to match(/works\.pdf\?as=title_labels&amp;foreground_color=ffff00&amp;resource_variant=public&amp;show_logo=false/)
        expect(response.body).to match(/works\.pdf\?as=title_labels&amp;foreground_color=000000&amp;resource_variant=public&amp;show_logo=true/)
        expect(response.body).to match(/works\.pdf\?as=title_labels&amp;foreground_color=000000&amp;qr_code_enabled=true&amp;resource_variant=public&amp;show_logo=true/)
      end
    end
  end

  describe "GET /collections/:collection_id/works/:id #show" do
    let(:work) { works(:work1) }

    {compliance: false, advisor: true, appraiser: true, facility_manager: false}.each do |role, can_see|
      describe role.to_s do
        it "should #{"not " unless can_see} show internal comments and price reference" do
          sign_in(users(role))
          get(:show, params: {collection_id: collection.id, id: work.id})
          if can_see
            expect(response.body).to match "Internal price reference for work 1"
            expect(response.body).to match "Interne opmerking bij werk 1"
          else
            expect(response.body).not_to match "Internal price reference for work 1"
            expect(response.body).not_to match "Interne opmerking bij werk 1"
          end
        end
      end
    end
  end

  describe "PATCH/PUT /collections/:collection_id/works/:id (#update)" do
    it "shouldn't change anything by default" do
      work = works(:work1)
      # work1:
      #   title: Work1
      #   grade_within_collection: A
      #   themes:
      #     - :earth
      #     - :wind
      #   subset: :contemporary
      #   collection: :collection_with_works
      #   artists:
      #     - :artist1
      put :update, params: {collection_id: work.collection.to_param, id: work.to_param, work: {title: "Werk1"}}
      work.reload
      expect(work.title).to eq("Work1")
    end
    it "shouldn't be change title when role == facility" do
      work = works(:work1)
      sign_in users(:facility_manager)
      put :update, params: {collection_id: work.collection.to_param, id: work.to_param, work: {title: "Werk1"}}
      work.reload
      expect(work.title).to eq("Work1")
    end
    it "shouldn't be change location when role == facility" do
      work = works(:work1)
      sign_in users(:facility_manager)
      expect(work.location).to eq("Adres")
      put :update, params: {collection_id: work.collection.to_param, id: work.to_param, work: {location: "werk", location_detail: "Mijn kantoor"}}
      work.reload
      expect(work.location).to eq("werk")
      expect(work.location_detail).to eq("Mijn kantoor")
    end
    it "qkunst admin should be able to edit all fields" do
      work = works(:work1)
      sign_in users(:admin)
      expect(work.location).to eq("Adres")
      valid_data = {
        location: "werk", internal_comments: "Interne beslommering", title: "Titel"
      }
      put :update, params: {collection_id: work.collection.to_param, id: work.to_param, work: valid_data}
      work.reload
      valid_data.each do |k, v|
        expect(work.send(k)).to eq(v)
      end
    end
  end
end
