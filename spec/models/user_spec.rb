# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                                     :bigint           not null, primary key
#  admin                                  :boolean
#  advisor                                :boolean
#  api_key                                :string
#  app                                    :boolean          default(FALSE)
#  appraiser                              :boolean
#  collection_accessibility_serialization :text
#  compliance                             :boolean
#  confirmation_sent_at                   :datetime
#  confirmation_token                     :string
#  confirmed_at                           :datetime
#  current_sign_in_at                     :datetime
#  current_sign_in_ip                     :string
#  domain                                 :string
#  email                                  :string           default(""), not null
#  encrypted_password                     :string           default(""), not null
#  facility_manager                       :boolean
#  facility_manager_support               :boolean
#  failed_attempts                        :integer          default(0), not null
#  filter_params                          :text
#  last_sign_in_at                        :datetime
#  last_sign_in_ip                        :string
#  locked_at                              :datetime
#  name                                   :string
#  oauth_access_token                     :string
#  oauth_expires_at                       :bigint
#  oauth_id_token                         :string
#  oauth_provider                         :string
#  oauth_refresh_token                    :string
#  oauth_subject                          :string
#  qkunst                                 :boolean
#  raw_open_id_token                      :text
#  receive_mails                          :boolean          default(TRUE)
#  remember_created_at                    :datetime
#  reset_password_sent_at                 :datetime
#  reset_password_token                   :string
#  role_manager                           :boolean
#  sign_in_count                          :integer          default(0), not null
#  super_admin                            :boolean          default(FALSE)
#  unconfirmed_email                      :string
#  unlock_token                           :string
#  created_at                             :datetime         not null
#  updated_at                             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
require "rails_helper"

RSpec.describe User, type: :model do
  describe "methods" do
    describe "#accessible_collections" do
      it "should return all collections when admin (except when not qkunst managed)" do
        u = users(:admin)
        expect(u.accessible_collections.pluck(:id)).to eq(Collection.all.pluck(:id) - [collections(:not_qkunst_managed_collection).id])
      end
      it "should return all collections when the user is a super admin" do
        u = users(:super_admin)
        expect(u.accessible_collections).to eq(Collection.all)
      end
      it "should return all collections and sub(sub)collections the user has access to" do
        u = users(:qkunst_with_collection)
        expect(u.accessible_collections).not_to eq(Collection.all)
        expect(u.accessible_collections.map(&:id).sort).to eq([collections(:collection1), collections(:collection2), collections(:collection4), collections(:collection_with_works), collections(:collection_with_works_child)].map(&:id).sort)
      end
      it "should restrict find" do
        u = users(:qkunst_with_collection)
        expect(u.accessible_collections.find(collections(:collection1).id)).to eq(collections(:collection1))
        assert_raises(ActiveRecord::RecordNotFound) do
          u.accessible_collections.find(collections(:collection3).id)
        end
      end
    end
    describe "#accessible_artists" do
      it "should return all artists for admin" do
        u = users(:admin)
        expect(u.accessible_artists).to eq(Artist.all)
      end

      it "should return a subset for users with a single collection" do
        u = users(:qkunst_with_collection)
        artists = collections(:collection1).works_including_child_works.flat_map { |w| w.artists }
        expect(u.accessible_artists.pluck(:id).sort).to eq(artists.map(&:id).sort)
      end
    end
    describe "#accessible_works" do
      it "should return all works for admin" do
        u = users(:admin)
        expect(u.accessible_works).to eq(Work.all)
      end

      it "should return a subset for users with a single collection" do
        u = users(:qkunst_with_collection)
        expect(u.accessible_works.pluck(:id).sort).to eq(collections(:collection1).works_including_child_works.pluck(:id).sort)
      end
    end
    describe "#accessible_time_spans" do
      it "should return all timespans for admin" do
        u = users(:admin)
        expect(u.accessible_time_spans.pluck(:id).sort).to eq(TimeSpan.all.pluck(:id).sort)
      end
      it "should not return all timespans for admin" do
        u = users(:collection_with_works_child_user)
        # root > collection1 > collection_with_works > collection_with_works_child
        expect(u.accessible_time_spans.pluck(:id).sort).not_to eq(TimeSpan.all.pluck(:id).sort)
      end
      it "should return all timespans for subcollections" do
        u = users(:collection_with_works_child_user)
        expect(u.collections).to eq([collections(:collection_with_works_child)])
        %w[time_span_contact_2].each do |ts|
          expect(u.accessible_time_spans.pluck(:id)).to include(time_spans(ts).id)
        end
      end
      it "should return timespans from parent collections of collection_with_works_child" do
        u = users(:collection_with_works_child_user)
        expect(u.collections).to eq([collections(:collection_with_works_child)])
        %w[time_span_future time_span_expired].each do |ts|
          expect(u.accessible_time_spans.pluck(:id)).to include(time_spans(ts).id)
        end
      end
    end

    describe "#accessible_work_sets" do
      it "should return all timespans for admin" do
        u = users(:admin)
        expect(u.accessible_work_sets.pluck(:id).sort).to eq(WorkSet.all.pluck(:id).sort)
      end
      it "should not return timespans for collection with works child user" do
        u = users(:collection_with_works_child_user)
        # root > collection1 > collection_with_works > collection_with_works_child
        expect(u.accessible_work_sets.pluck(:id).sort).to be_empty
      end
      it "should return a timespan for qkunst_with_collection" do
        u = users(:qkunst_with_collection)
        expect(u.accessible_work_sets.pluck(:id).sort).to include(work_sets(:work_set_collection1).id)
        expect(u.accessible_work_sets.pluck(:id).sort).not_to eq(WorkSet.all.pluck(:id).sort)
      end
    end
    describe "#collection_ids" do
      it "should return ids of collections" do
        expect(users(:qkunst_with_collection).collection_ids.sort).to eq(users(:qkunst_with_collection).collections.map(&:id).sort)
      end
    end
    describe "#collection_accessibility_log" do
      it "should be empty when new" do
        u = User.new({email: "test@example.com", password: "tops3crt!", password_confirmation: "tops3crt!"})
        expect(u.collection_accessibility_serialization).to eq({})
        u.save
        u.reload
        expect(u.collection_accessibility_serialization).to eq({})
      end
      it "should log accessible projects with name and id on save" do
        u = users(:user3)
        expect(u.collection_accessibility_serialization).to eq({})
        c = collections(:collection1)
        u.collections << c
        u.save
        u.reload
        expect(u.collection_accessibility_serialization).to eq({c.id => c.name})
      end
      it "should log accessible projects with name and id on update" do
        u = users(:user3)
        expect(u.collection_accessibility_serialization).to eq({})
        c = collections(:collection1)
        u.update(collections: [c])
        u.reload
        expect(u.collection_accessibility_serialization).to eq({c.id => c.name})
      end
      it "should log accessible projects with name and id on update with ids" do
        u = users(:user3)
        expect(u.collection_accessibility_serialization).to eq({})
        c = collections(:collection1)
        u.update(collection_ids: [c.id])
        u.reload
        expect(u.collection_accessibility_serialization).to eq({c.id => c.name})
      end
      it "should be retrievable from an earlier version" do
        u = users(:user3)
        expect(u.collection_accessibility_serialization).to eq({})
        c1 = collections(:collection1)
        u.update(collections: [c1])
        u.reload
        c2 = collections(:collection2)
        u.update(collections: [c2])
        u.reload
        expect(u.versions.last.reify.collection_accessibility_serialization).to eq({c1.id => c1.name})
      end
    end
    describe "#name" do
      it "should return name when set" do
        expect(users(:admin).name).to eq("Administrator")
      end
      it "should return email when not set" do
        expect(users(:user1).name).to eq(users(:user1).email)
      end
    end
    describe "#oauthable?" do
      {supposed_admin_without_oauth: false, admin: true, collection_with_works_user: true, compliance: false, advisor: false, appraiser: false}.each do |k, v|
        context k do
          let(:user) { users(k) }
          it "should return #{v}" do
            expect(user.oauthable?).to eq(v)
          end
        end
      end
    end
    describe "#role" do
      it "should return read_only by default" do
        u = User.new
        expect(u.role).to eq(:read_only)
      end
      it "should return admin for admin" do
        expect(users(:admin).role).to eq(:admin)
      end
      it "should return not admin when supposedly admin" do
        u = users(:supposed_admin_without_oauth)
        expect(u.role).to eq(:read_only)
      end
    end
    describe "#roles" do
      it "should return read_only by default" do
        u = User.new
        expect(u.roles).to eq([:read_only])
      end
      it "should return read_only by default, even for admin" do
        u = users(:admin)
        expect(u.roles).to eq([:admin, :read_only])
      end
    end
    describe "#super_admin?" do
      it "should return false for regular admin" do
        expect(users(:admin).super_admin?).to eq(false)
      end
      it "should return true for super admin" do
        expect(users(:super_admin).super_admin?).to eq(true)
      end
    end
    describe "#works_created" do
      it "should count 2 for admin" do
        u = users(:admin)
        expect(u.works_created.count).to eq(2)
      end
    end
    describe "#accessible_users" do
      it "should return all users when admin" do
        expect(users(:admin).accessible_users.all.collect { |a| a.email }.sort).to eq(User.all.collect { |a| a.email }.sort)
      end
      it "should return no users when qkunst" do
        expect(users(:qkunst).accessible_users.all).to eq([])
      end
      it "should return subset of users when advisor" do
        # collection1:
        #   collection2:
        #     collection4:
        #   collection_with_works:
        accessible_users = users(:advisor).accessible_users.all

        expect(accessible_users).to include(users(:user1))
        expect(accessible_users).to include(users(:user2))
        expect(accessible_users).to include(users(:user3))
        expect(accessible_users).to include(users(:qkunst_with_collection))
        expect(accessible_users).to include(users(:user_with_no_rights))
        expect(accessible_users).to include(users(:appraiser))
        expect(accessible_users).to include(users(:advisor))
        expect(accessible_users).not_to include(users(:admin))
        expect(accessible_users).not_to include(users(:read_only)) # collection3 isn't in collection 1 tree
      end
    end
    describe "#accessible_roles" do
      manager_role_roles = [:advisor, :compliance, :qkunst, :appraiser, :facility_manager, :read_only]

      it "should return all for admin" do
        expect(users(:admin).accessible_roles).to eq(User::ROLES)
      end

      it "should return nil for regular advisor" do
        expect(users(:advisor).accessible_roles).to eq([])
      end

      it "should return some for advisor with manager roles role (#{manager_role_roles.join(";")})" do
        advisor = users(:advisor)
        advisor.role_manager = true
        expect(advisor.accessible_roles).to eq(manager_role_roles)
      end
    end
  end
  describe "Class methods" do
    describe ".from_omniauth_callback_data" do
      it "raises argument error when invalid data is passed" do
        expect { User.from_omniauth_callback_data(nil) }.to raise_error(ArgumentError)
        expect { User.from_omniauth_callback_data(Users::OmniauthCallbackData.new) }.to raise_error(ArgumentError)
      end
      it "creates a new user when given" do
        email = "a@a.com"
        User.where(email: email).destroy_all
        new_user = User.from_omniauth_callback_data(Users::OmniauthCallbackData.new(email: email, oauth_provider: "google_oauth2", oauth_subject: "123", email_confirmed: false))
        expect(new_user.persisted?).to eq(true)
        expect(new_user.qkunst).to be_falsey
        expect(new_user.email).to eq(email)
        expect(new_user.oauth_provider).to eq("google_oauth2")
        expect(new_user.oauth_subject).to eq("123")
        expect(new_user.confirmed?).to eq(false)
        expect(new_user).to be_a(User)
      end
      it "creates a new user when given and confirms when confirmed" do
        email = "a@a.com"
        User.where(email: email).destroy_all
        new_user = User.from_omniauth_callback_data(Users::OmniauthCallbackData.new(email: email, oauth_provider: "google_oauth2", oauth_subject: "123", email_confirmed: true))
        expect(new_user.persisted?).to eq(true)
        expect(new_user.qkunst).to be_falsey
        expect(new_user.email).to eq(email)
        expect(new_user.oauth_provider).to eq("google_oauth2")
        expect(new_user.oauth_subject).to eq("123")
        expect(new_user.confirmed?).to eq(true)
        expect(new_user).to be_a(User)
      end
      it "auto subscribes a user to a role when configured as such" do
        email = "a@a.com"
        User.where(email: email).destroy_all
        new_user = User.from_omniauth_callback_data(Users::OmniauthCallbackData.new(email: email, oauth_provider: "google_oauth2", oauth_subject: "123", email_confirmed: true, roles: ["jfjfjk"], issuer: "microsoft/abc"))

        expect(new_user.facility_manager?).to be_truthy
        expect(new_user.collections).not_to include(collections(:collection1))
      end
      it "auto subscribes a user to a role and group when configured as such" do
        email = "a@a.com"
        User.where(email: email).destroy_all
        new_user = User.from_omniauth_callback_data(Users::OmniauthCallbackData.new(email: email, oauth_provider: "google_oauth2", oauth_subject: "123", email_confirmed: true, roles: ["jfjfjk"], groups: ["jfaaa", "jfaab"], issuer: "microsoft/abc"))

        expect(new_user.facility_manager?).to be_truthy
        expect(new_user.collections).to include(collections(:collection1))
      end
      it "auto overides a user's memberschip when configured as such" do
        email = users(:facility_manager).email
        existing_user = User.from_omniauth_callback_data(Users::OmniauthCallbackData.new(email: email, oauth_provider: "google_oauth2", oauth_subject: "123", email_confirmed: true, roles: ["jfjfjk"], groups: ["jfaaa", "jfaab"], issuer: "microsoft/abc"))

        expect(existing_user.facility_manager?).to be_truthy
        expect(existing_user.collections).to include(collections(:collection1))
      end
      it "auto overides a user's memberschip when configured as such" do
        email = users(:appraiser).email
        existing_user = User.from_omniauth_callback_data(Users::OmniauthCallbackData.new(email: email, oauth_provider: "google_oauth2", oauth_subject: "123", email_confirmed: true, roles: ["jfjfjk"], groups: ["jfaaa", "jfaab"], issuer: "microsoft/abc"))

        expect(existing_user.facility_manager?).to be_truthy
        expect(existing_user.appraiser?).to be_falsey
        expect(existing_user.collections).to include(collections(:collection1))
        expect(existing_user.collections).not_to include(collections(:collection3))
      end
      it "leaves a user's memberschip as is when not configured as such" do
        email = users(:appraiser).email
        existing_user = User.from_omniauth_callback_data(Users::OmniauthCallbackData.new(email: email, oauth_provider: "google_oauth2", oauth_subject: "123", email_confirmed: true, roles: ["jfjfjk"], groups: ["jfaaa", "jfaab"], issuer: "micfrosoft/abc"))

        expect(existing_user.facility_manager?).to be_falsey
        expect(existing_user.appraiser?).to be_truthy
        expect(existing_user.collections).to include(collections(:collection1))
        expect(existing_user.collections).to include(collections(:collection3))
      end
      it "it updates account, even when case doesn't match" do
        email = users(:appraiser).email.upcase
        existing_user = User.from_omniauth_callback_data(Users::OmniauthCallbackData.new(email: email, oauth_provider: "google_oauth2", oauth_subject: "123", email_confirmed: true, roles: ["jfjfjk"], groups: ["jfaaa", "jfaab"], issuer: "micfrosoft/abc"))

        expect(existing_user.facility_manager?).to be_falsey
        expect(existing_user.appraiser?).to be_truthy
        expect(existing_user.collections).to include(collections(:collection1))
        expect(existing_user.collections).to include(collections(:collection3))
      end
    end
  end
  describe "Scopes" do
  end
  describe "Callbacks" do
    describe "name change should result in name changes with work" do
      it "should change" do
        u = users(:admin)

        expect(UpdateCachedUserNamesWorker).to receive(:perform_async).with(u.id)

        w = collections(:collection1).works.create(created_by: u)
        expect(w.created_by_name).to eq("Administrator")
        u.name = "Administrateur"
        u.save
        # simulate
        UpdateCachedUserNamesWorker.new.perform(u.id)
        w.reload
        expect(w.created_by_name).to eq("Administrateur")
      end
    end
  end
end
