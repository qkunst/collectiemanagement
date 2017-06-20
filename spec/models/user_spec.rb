require 'rails_helper'

RSpec.describe User, type: :model do
  describe "methods" do
    describe "#roles" do
      it "should return read_only by default" do
        u = User.new
        expect(u.roles).to eq([:read_only])
      end
      it "should return read_only by default" do
        u = users(:admin)
        expect(u.roles).to eq([:admin, :qkunst, :read_only])
      end
    end
    describe "#accessible_collections" do
      it "should return all collections when admin" do
        u = users(:admin)
        expect(u.accessible_collections).to eq(Collection.all)
      end
      it "should return all collections and sub(sub)collections the user has access to" do
        u = users(:qkunst_with_collection)
        expect(u.accessible_collections).not_to eq(Collection.all)
        expect(u.accessible_collections.map(&:id).sort).to eq([collections(:collection1),collections(:collection2),collections(:collection4),collections(:collection_with_works)].map(&:id).sort)
      end
      it "should restrict find" do
        u = users(:qkunst_with_collection)
        expect(u.accessible_collections.find(collections(:collection1).id)).to eq(collections(:collection1))
        assert_raises(ActiveRecord::RecordNotFound) do
          u.accessible_collections.find(collections(:collection3).id)
        end
      end
    end
    describe "#collection_accessibility_log" do
      it "should be empty when new" do
        u = User.new({ email: 'test@example.com', password: "tops3crt!", password_confirmation: "tops3crt!" })
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
  end
  describe "Class methods" do
  end
  describe "Scopes" do
  end
end
