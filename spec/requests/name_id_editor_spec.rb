# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin level management", type: :request do
  [
    "conditions",
    "currencies",
    "damage_types",
    "frame_damage_types",
    "frame_types",
    "media",
    "object_categories",
    "placeabilities",
    "sources",
    "subsets",
    "techniques",
    "themes",
    "work_statuses"
  ].each do | name_id_admin_resource |
    describe name_id_admin_resource do
      let(:constant) { name_id_admin_resource.singularize.camelize.constantize }
      constant = name_id_admin_resource.singularize.camelize.constantize

      describe "GET /#{name_id_admin_resource}" do
        let(:path) { send("#{name_id_admin_resource}_path") }

        it "ignores anonymous request" do
          get path
          expect(response).to have_http_status(302)
        end
        it "ignores advisor request" do
          sign_in users(:advisor)
          get path
          expect(response).to have_http_status(302)
        end
        it "adheres to admin request" do
          sign_in users(:admin)
          get path
          expect(response).to have_http_status(200)
        end
      end
      describe "GET /#{name_id_admin_resource}/new" do
        let(:path) { send("new_#{name_id_admin_resource.singularize}_path") }

        it "ignores anonymous request" do
          get path
          expect(response).to have_http_status(302)
        end
        it "ignores advisor request" do
          sign_in users(:advisor)
          get path
          expect(response).to have_http_status(302)
        end
        it "adheres to admin request" do
          sign_in users(:admin)
          get path
          expect(response).to have_http_status(200)
        end
      end

      describe "POST /#{name_id_admin_resource}" do
        let(:path) { send("#{name_id_admin_resource}_path") }

        it "does not change #{constant}.count when performed by anonymous" do
          expect {
            post path, params: { name_id_admin_resource.singularize => {name: "Nieuwe naam"} }
          }.not_to change(constant, :count)
        end
        it "does not change #{constant}.count when performed by advisor" do
          sign_in users(:advisor)
          expect {
            post path, params: { name_id_admin_resource.singularize => {name: "Nieuwe naam"} }
          }.not_to change(constant, :count)
        end
        it "changes #{constant}.count by 1 when performed by admin" do
          sign_in users(:admin)
          expect {
            post path, params: { name_id_admin_resource.singularize => {name: "Nieuwe naam"} }
          }.to change(constant, :count).by(1)
        end
      end

    end
  end
end
