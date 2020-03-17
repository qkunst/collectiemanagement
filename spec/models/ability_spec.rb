# frozen_string_literal: true

require "rails_helper"

RSpec.describe Ability, type: :model do
  example_groups = {
    advisor: {
      "Alias workings" => [
        [:manage_collection, :collection, :collection_with_works, true],
        [:review_collection, :collection, :collection_with_works, true]
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
