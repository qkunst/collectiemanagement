# frozen_string_literal: true

require "rails_helper"

RSpec.describe Collection::UsersController, type: :request do
  let(:collection) { collections(:collection1) }

  describe "GET /collections/:id/users" do
    it "shouldn't be publicly accessible!" do
      get collection_users_path(collection)
      expect(response).to have_http_status(302)
    end

    {facility_manager: 302, appraiser: 302, advisor: 200, compliance: 200}.each do |user_type, http_status|
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

            expect(body).to match("read_only_user@murb.nl</strong><br/><small>Read-only</small>")
            expect(body).to match('<th>Collection with works child \(sub of Collection 1')
          end
        end
      end
    end
  end
end