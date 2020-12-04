# frozen_string_literal: true

require "rails_helper"

RSpec.describe Collection::UsersController, type: :request do
  include ActiveSupport::Testing::TimeHelpers

  let(:collection) { collections(:collection1) }

  describe "GET /collections/:id/users" do
    it "shouldn't be publicly accessible!" do
      get collection_users_path(collection)
      expect(response).to have_http_status(302)
    end

    {facility_manager: 302, appraiser: 302, advisor: 200, compliance: 200, admin: 200}.each do |user_type, http_status|
      context user_type do
        before do
          sign_in users(user_type)
        end

        it "should return #{http_status}" do
          get collection_users_path(collection)
          expect(response).to have_http_status(http_status)
        end

        if http_status == 200
          it "should show users" do
            get collection_users_path(collection)
            body = response.body
            expect(body).to match(%r{<tr>\s*<th>Gebruiker</th>\s*<th>Collection 1</th>\s*<th>Collection 2 \(sub of Collection 1\)</th>\s*<th>Collection 4</th>\s*<th>Collection with works \(sub of Collection 1\)</th>\s*<th>Collection with works child \(sub of Collection 1 &gt;&gt; colection with works\)</th>\s*</tr>})
            expect(body).to match(%r{<td>✔︎</td>\s*<td>✔︎</td>\s*<td>✔︎</td>\s*<td>✔︎</td>\s*<td>✔︎</td>\s*})
            expect(body).to match(%r{read_only\@murb\.nl.*\s*.*<\/th>\s*<td>✔︎</td>\s*<td>✔︎</td>\s*<td>✔︎</td>\s*<td>✔︎</td>\s*<td>✔︎</td>\s*</tr>})
            expect(body).to match(%r{read_only@murb.nl.*\s*.*</strong><br/><small>Read-only</small>})
            expect(body).to match('<th>Collection with works child \(sub of Collection 1')

          end

          it "should show users from a few collections deep" do
            get collection_users_path(collection)
            body = response.body
            expect(body).to match(%r{collection_with_works_child@murb.nl.*\s*.*</th>\s*<td>✘</td>\s*<td>✘</td>\s*<td>✘</td>\s*<td>✘</td>\s*<td>✔︎</td>\s*</tr>})
          end
        end
      end
    end
  end

  describe "POST /collection/:collection_id/users/:id" do
    let(:user) { users(:read_only) }
    let(:valid_params)  {{user: {role: :facility_manager, collection_ids: [:collection1, :collection_with_stages_child].map{|ud| collections(ud).id}  }}}
    let(:patch_user) { patch collection_user_path(collection, user), params: valid_params }

    it "shouldn't be publicly accessible!" do
      expect { patch_user }.not_to change(user, :updated_at)
      expect(response).to have_http_status(302)
    end

    context "not a role manager" do
      %w[facility_manager appraiser advisor compliance].each do |user_type|
        context user_type do
          before do
            sign_in  users(user_type)
          end

          it "should not update" do
            travel_to(1.day.from_now) do
              user_updated_at = user.updated_at.to_s

              patch_user
              expect(user.reload.updated_at.to_s).to eq(user_updated_at)
              expect(response).to have_http_status(302)
            end
          end

          it "should update collection ids" do
            patch_user
            user.reload

            expect(user.collection_ids).to include(collections(:collection1).id)
          end

          context "user with existing roles" do
            let(:user) { u = users(:read_only); u.update(collections: [:collection1, :collection_with_stages_child].map{|a| collections(a)}); u }
            let(:valid_params)  {{user: {role: :facility_manager, collection_ids: []}  }}

            it "should leave existing collections in tact" do
              patch_user
              user.reload
              expect(user.collection_ids).to include(collections(:collection_with_stages_child).id)
              expect(user.collection_ids).to include(collections(:collection1).id)
            end
          end
        end
      end
    end

    context "role manager" do
      %w[facility_manager appraiser advisor compliance admin].each do |user_type|
        context user_type do
          before do
            editing_user = users(user_type)
            editing_user.update(role_manager: true)
            sign_in editing_user
          end

          it "should update" do
            travel_to(1.day.from_now) do
              user_updated_at = user.updated_at.to_s

              patch_user
              expect(user.reload.updated_at.to_s).not_to eq(user_updated_at)
              expect(response).to have_http_status(302)
            end
          end

          it "should update collection ids" do
            patch_user
            user.reload

            expect(user.collection_ids).to include(collections(:collection1).id)
          end

          unless user_type == "admin"
            it "should not allow editing roles outside current scope" do
              patch_user
              user.reload
              expect(user.collection_ids).not_to include(collections(:collection_with_stages_child).id)
            end
          end

          context "user with existing roles" do
            let(:user) { u = users(:read_only); u.update(collections: [:collection1, :collection_with_stages_child].map{|a| collections(a)}); u }
            let(:valid_params)  {{user: {role: :facility_manager, collection_ids: []}  }}

            it "should leave existing collections in tact" do
              patch_user
              user.reload
              expect(user.collection_ids).to include(collections(:collection_with_stages_child).id) unless user_type == "admin"
              expect(user.collection_ids).not_to include(collections(:collection1).id)
            end
          end
        end
      end
    end


  end
end
