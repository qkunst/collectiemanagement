# frozen_string_literal: true

require "rails_helper"

RSpec.describe Ability, type: :model do
  example_groups = {
    admin: {
      "Works" => [
        [:read, :work, :work1, true],
        [:edit, :work, :work1, true],
        [:edit_location, :work, :work1, true],
        [:read, :work, :work6, true],
        [:show_details, :work, :work1, true]
      ],
      "Users" => [
        [:update, :user, :user_with_no_rights, true]
      ]
    },
    advisor: {
      "Test: alias working of :manage_collection" => [
        [:manage_collection, :collection, :collection_with_works, true],
        [:review_collection, :collection, :collection_with_works, true]
      ],
      "Works" => [
        [:read, :work, :work1, true],
        [:edit, :work, :work1, true],
        [:edit_location, :work, :work1, true],
        [:read, :work, :work6, false],
        [:show_details, :work, :work1, true]
      ],
      "Users" => [
        [:update, :user, :user_with_no_rights, false]
      ]
    },
    compliance: {
      "Collections" => [
        [:read, :collection, :collection_with_works, true],
        [:read, :collection, :collection3, false],
        [:manage_collection, :collection, :collection_with_works, false],
        [:review_collection, :collection, :collection_with_works, true],
        [:read_extended_report, :collection, :collection_with_works, true]
      ],
      "Works" => [
        [:read, :work, :work1, true],
        [:edit, :work, :work1, false],
        [:edit_location, :work, :work1, false],
        [:read, :work, :work6, false],
        [:show_details, :work, :work1, true]
      ]
    },
    appraiser: {
      "Collections" => [
        [:read, :collection, :collection_with_works, true],
        [:read, :collection, :collection3, true],
        [:read, :collection, :collection_with_stages, false],
        [:manage_collection, :collection, :collection_with_works, false],
        [:review_collection, :collection, :collection_with_works, false],
        [:read_report, :collection, :collection_with_works, true],
        [:read_extended_report, :collection, :collection_with_works, true]
      ],
      "Works" => [
        [:read, :work, :work1, true],
        [:edit, :work, :work1, true],
        [:edit_location, :work, :work1, true],
        [:read, :work, :work6, true],
        [:read, :work, :work_with_private_theme, false],
        [:show_details, :work, :work1, true]
      ]
    },
    facility_manager: {
      "Collections" => [
        [:read, :collection, :collection_with_works, true],
        [:read, :collection, :collection3, false],
        [:manage_collection, :collection, :collection_with_works, false],
        [:review_collection, :collection, :collection_with_works, false],
        [:read_report, :collection, :collection_with_works, true],
        [:read_extended_report, :collection, :collection_with_works, false]
      ],
      "Works" => [
        [:read, :work, :work1, true],
        [:edit, :work, :work1, false],
        [:edit_location, :work, :work1, true],
        [:read, :work, :work6, false],
        [:show_details, :work, :work1, true]
      ]
    }
  }

  example_groups.each do |k1, v1|
    context k1 do
      let(:user) { Ability.new(users(k1)) }
      v1.each do |k2, v2|
        describe k2 do
          v2.each do |v3|
            it "#{v3[3] ? "can" : "cannot"} #{v3[0]} #{v3[1]}(:#{v3[2]})" do
              test_obj = send(v3[1].to_s.pluralize.to_sym, v3[2])
              expect(user.can?(v3[0], test_obj)).to eq(v3[3])
            end
          end
        end
      end
    end
  end

  describe "Role manager role" do
    example_groups.each do |k1, v1|
      context "when added to #{k1}" do
        let(:user) do
          user = users(k1)
          user.role_manager = true
          Ability.new(user)
        end
        it "can update anonymous users for a collection" do
          expect(user.can?(:update, users(:user_with_no_rights))).to eq(true)
        end
        it "#{k1 == :admin ? "can" : "cannot"} update an admin user" do
          expect(user.can?(:update, users(:admin))).to eq(k1 == :admin)
        end
        it "#{k1 == :admin ? "can" : "cannot"} update self" do
          expect(user.can?(:update, users(k1))).to eq(k1 == :admin)
        end
        it "#{k1 == :admin ? "can" : "cannot"} update an user from another collection" do
          expect(user.can?(:update, users(:read_only_with_access_to_collection_with_stages))).to eq(k1 == :admin)
        end
        it "can update an user from current collection" do
          expect(user.can?(:update, users(:user1))).to eq(true)
        end
      end
    end
  end

  describe "report related functions" do
    describe ".report_field_abilities" do
      it "should report field abilities" do
        field_abilities = Ability.report_field_abilities
        expect(field_abilities[:header][0][:ability]).to be_a(Ability)
        expect(field_abilities[:header][0][:user]).to be_a(Ability::TestUser)
        expect(field_abilities.dig(:data, :works_attributes, :location)).to be_a(Array)
      end
    end

    describe ".report_abilities" do
      it "should report field abilities" do
        report = Ability.report_abilities
        expect(report[:header][0][:ability]).to be_a(Ability)
        expect(report[:header][0][:user]).to be_a(Ability::TestUser)

        expect(report.dig(:data, "Alles", "Beheren")).to eq([true, false, false, false, false, false])
        expect(report.dig(:data, "Werk", "Bewerken")).to eq([true, true, false, true, false, false])
      end
    end
  end
end
