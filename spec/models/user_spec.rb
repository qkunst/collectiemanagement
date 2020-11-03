# frozen_string_literal: true

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
    describe "#collection_ids" do
      it "should return ids of collections" do
        expect(users(:qkunst_with_collection).collection_ids).to eq(users(:qkunst_with_collection).collections.map(&:id))
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
    describe "#role" do
      it "should return read_only by default" do
        u = User.new
        expect(u.role).to eq(:read_only)
      end
      it "should return read_only by default" do
        u = users(:admin)
        expect(u.role).to eq(:admin)
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
