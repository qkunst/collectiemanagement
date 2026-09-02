# frozen_string_literal: true

require "rails_helper"

RSpec.describe Ability, "[QSECIMP0005]", type: :model do
  example_groups = {
    super_admin: {
      "Collections" => [
        [:read, :collection, :collection_with_stages, true],
        [:read, :collection, :not_qkunst_managed_collection, true],
        [:read, :collection, :collection_with_works, true],
        [:read, :collection, :collection3, true],
        [:manage_collection, :collection, :collection_with_works, true],
        [:review_collection, :collection, :collection_with_works, true],
        [:read_report, :collection, :collection_with_works, true],
        [:read_extended_report, :collection, :collection_with_works, true]
      ],
      "Works" => [
        [:destroy, :work, :work1, true],
        [:read, :work, :work1, true],
        [:edit, :work, :work1, true],
        [:edit, :work, :work6, true],
        [:read, :work, :work_with_private_theme, true],
        [:edit_location, :work, :work1, true],
        [:edit_purchase_information, :work, :work1, true],
        [:read, :work, :work6, true],
        [:show_details, :work, :work1, true],
        [:edit_source_information, :work, :work1, true]
      ],
      "Users" => [
        [:update, :user, :user_with_no_rights, true]
      ]
    },
    admin: {
      "Collections" => [
        [:read, :collection, :not_qkunst_managed_collection, false],
        [:read, :collection, :collection_with_works, true],
        [:read, :collection, :collection3, true],
        [:read, :collection, :collection_with_stages, true],
        [:manage_collection, :collection, :collection_with_works, true],
        [:review_collection, :collection, :collection_with_works, true],
        [:read_report, :collection, :collection_with_works, true],
        [:read_extended_report, :collection, :collection_with_works, true]
      ],
      "Works" => [
        [:destroy, :work, :work1, true],
        [:read, :work, :work1, true],
        [:edit, :work, :work6, true],
        [:edit, :work, :work1, true],
        [:edit_location, :work, :work1, true],
        [:read, :work, :work6, true],
        [:edit_source_information, :work, :work1, true],
        [:edit_purchase_information, :work, :work1, true],
        [:show_details, :work, :work1, true],
        [:read, :work, :work_with_private_theme, true]
      ],
      "Users" => [
        [:update, :user, :user_with_no_rights, true]
      ]
    },
    advisor: {
      "Collections" => [
        [:read, :collection, :collection_with_works, true],
        [:read, :collection, :collection3, false],
        [:manage_collection, :collection, :collection_with_works, true],
        [:read_report, :collection, :collection_with_works, true],
        [:read, :collection, :not_qkunst_managed_collection, false],
        [:review_collection, :collection, :collection_with_works, true],
        [:read, :collection, :collection_with_stages, false],
        [:read_extended_report, :collection, :collection_with_works, true]
      ],
      "Works" => [
        [:read, :work, :work1, true],
        [:destroy, :work, :work1, false],
        [:edit, :work, :work1, true],
        [:edit_location, :work, :work1, true],
        [:read, :work, :work6, false],
        [:edit, :work, :work6, false],
        [:show_details, :work, :work1, true],
        [:edit_source_information, :work, :work1, true],
        [:edit_purchase_information, :work, :work1, true],
        [:read, :work, :work_with_private_theme, false]
      ],
      "Users" => [
        [:update, :user, :user_with_no_rights, false] # by default advisors canot edit user roles
      ]
    },
    compliance: {
      "Collections" => [
        [:read, :collection, :collection_with_stages, false],
        [:read, :collection, :collection_with_works, true],
        [:read, :collection, :collection3, false],
        [:manage_collection, :collection, :collection_with_works, false],
        [:read_report, :collection, :collection_with_works, true],
        [:review_collection, :collection, :collection_with_works, true],
        [:read_extended_report, :collection, :collection_with_works, true],
        [:read, :collection, :not_qkunst_managed_collection, false]
      ],
      "Works" => [
        [:destroy, :work, :work1, false],
        [:read, :work, :work1, true],
        [:edit, :work, :work1, false],
        [:read, :work, :work6, false],
        [:edit_location, :work, :work1, false],
        [:edit_source_information, :work, :work1, false],
        [:edit_purchase_information, :work, :work1, false],
        [:read, :work, :work6, false],
        [:show_details, :work, :work1, true],
        [:read, :work, :work_with_private_theme, false],
        [:edit, :work, :work6, false]
      ],
      "Users" => [
        [:update, :user, :user_with_no_rights, false]
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
        [:read, :collection, :not_qkunst_managed_collection, false],
        [:read_extended_report, :collection, :collection_with_works, true]
      ],
      "Works" => [
        [:read, :work, :work1, true],
        [:destroy, :work, :work1, false],
        [:edit, :work, :work1, true],
        [:edit, :work, :work6, true],
        [:read, :work, :work6, true],
        [:edit_source_information, :work, :work1, true],
        [:edit_purchase_information, :work, :work1, true],
        [:edit_location, :work, :work1, true],
        [:show_details, :work, :work1, true],
        [:read, :work, :work6, true],
        [:read, :work, :work_with_private_theme, false]
      ],
      "Users" => [
        [:update, :user, :user_with_no_rights, false]
      ]
    },
    facility_manager: {
      "Collections" => [
        [:read, :collection, :collection_with_stages, false],
        [:read, :collection, :collection_with_works, true],
        [:read, :collection, :collection3, false],
        [:manage_collection, :collection, :collection_with_works, false],
        [:review_collection, :collection, :collection_with_works, false],
        [:read_report, :collection, :collection_with_works, true],
        [:read, :collection, :not_qkunst_managed_collection, false],
        [:read_extended_report, :collection, :collection_with_works, false]
      ],
      "Works" => [
        [:read, :work, :work1, true],
        [:read, :work, :work_with_private_theme, false],
        [:edit_source_information, :work, :work1, false],
        [:edit_purchase_information, :work, :work1, false],
        [:edit, :work, :work6, false],
        [:destroy, :work, :work1, false],
        [:read, :work, :work6, false],
        [:edit, :work, :work1, false],
        [:edit_location, :work, :work1, true],
        [:read, :work, :work6, false],
        [:show_details, :work, :work1, true]
      ],
      "Users" => [
        [:update, :user, :user_with_no_rights, false]
      ]
    },
    registrator: {
      "Collections" => [
        [:read, :collection, :collection_with_works, true],
        [:read, :collection, :collection3, false],
        [:read, :collection, :collection_with_stages, false],
        [:read, :collection, :not_qkunst_managed_collection, false],
        [:manage_collection, :collection, :collection_with_works, false],
        [:review_collection, :collection, :collection_with_works, false],
        [:read_report, :collection, :collection_with_works, true],
        [:read_extended_report, :collection, :collection_with_works, true]
      ],
      "Works" => [
        [:read, :work, :work1, true],
        [:destroy, :work, :work1, false],
        [:edit, :work, :work1, true],
        [:edit_location, :work, :work1, true],
        [:show_details, :work, :work1, true],
        [:edit_source_information, :work, :work1, true],
        [:edit_purchase_information, :work, :work1, false],
        [:read, :work, :work6, false],
        [:read, :work, :work_with_private_theme, false],
        [:edit, :work, :work6, false]
      ],
      "Users" => [
        [:update, :user, :user_with_no_rights, false]
      ]
    }
  }

  example_groups.each do |k1, v1|
    context k1.to_s.humanize do
      let(:user) { Ability.new(users(k1)) }
      v1.each do |k2, v2|
        describe k2 do
          v2.each do |v3|
            it "#{v3[3] ? "can" : "can not"} #{v3[0]} #{v3[1]}(:#{v3[2]})".humanize do
              test_obj = send(v3[1].to_s.pluralize.to_sym, v3[2])
              expect(user.can?(v3[0], test_obj)).to eq(v3[3])
            end
          end
        end
      end
    end
  end

  describe "Examples are equal (meta test)" do
    all_keys = example_groups.values.map(&:keys).flatten.uniq

    expected_examples = example_groups.values.map { |k| k.map { |type, rules| [type, rules.pluck(0..2)] } }.each_with_object(all_keys.uniq.map { [it, []] }.to_h) { |item, res|
      item.each { |k, v|
        res[k] += v
        res[k].uniq!
      }
    }

    example_groups.each do |key, value|
      it "#{key} has all the same objects for each role" do
        expect(value.keys).to eq(all_keys)
      end

      describe key do
        value.each do |object, example_set|
          describe object do
            key_example_set = example_set.pluck(0..2).uniq
            expected_examples[object].each do |example|
              it "has example #{example.inspect}" do
                expect(key_example_set).to include(example)
              end
            end
          end
        end
      end
    end
  end

  # describe "Advisor of a non QKunst managed collection" do
  #   v1 = example_groups[:advisor].deep_dup
  #   let(:user) { Ability.new(users(:advisor)) }

  #   around do
  #     allow_any_instance_of(Collection).to receive(:qkunst_managed?).and_return
  #   end

  #   # Override 1 of 1: Advisors of QKunst managed collections can destroy works
  #   v1["Works"].select { |a| a[0] == :destroy }.each { |a| a[3] = true }

  #   v1.each do |k2, v2|
  #     describe k2 do
  #       v2.each do |v3|
  #         it "#{v3[3] ? "can" : "can not"} #{v3[0]} #{v3[1]}(:#{v3[2]})".humanize do
  #           test_obj = send(v3[1].to_s.pluralize.to_sym, v3[2])
  #           expect(user.can?(v3[0], test_obj)).to eq(v3[3])
  #         end
  #       end
  #     end
  #   end
  # end

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
        it "#{[:admin, :super_admin].include?(k1) ? "can" : "can not"} update an admin user" do
          expect(user.can?(:update, users(:admin))).to eq([:admin, :super_admin].include?(k1))
        end
        it "#{[:admin, :super_admin].include?(k1) ? "can" : "can not"} update self" do
          expect(user.can?(:update, users(k1))).to eq([:admin, :super_admin].include?(k1))
        end
        it "#{[:admin, :super_admin].include?(k1) ? "can" : "can not"} update an user from another collection" do
          expect(user.can?(:update, users(:read_only_with_access_to_collection_with_stages))).to eq([:admin, :super_admin].include?(k1))
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
        expect(field_abilities.dig(:data, "Werk", "Adres en/of gebouw(deel)")).to be_a(Array)
      end

      it "should report read field abilities" do
        field_abilities = Ability.report_field_abilities(ability: :read)
        expect(field_abilities[:header][0][:ability]).to be_a(Ability)
        expect(field_abilities[:header][0][:user]).to be_a(Ability::TestUser)
        expect(field_abilities.dig(:data, "Werk", "Adres en/of gebouw(deel)")).to be_a(Array)
      end

      it "should return fewer abilities for non reading" do
        edit_field_abilities = Ability.report_field_abilities(ability: :edit).dig(:data, "Werk", "Adres en/of gebouw(deel)")
        read_field_abilities = Ability.report_field_abilities(ability: :read).dig(:data, "Werk", "Adres en/of gebouw(deel)")
        count_edit_field_abilities = edit_field_abilities.count { |a| a == true }
        count_read_field_abilities = read_field_abilities.count { |a| a == true }
        expect(count_edit_field_abilities).to be < count_read_field_abilities
      end
    end

    describe ".report_abilities" do
      it "should report field abilities" do
        report = Ability.report_abilities
        expect(report[:header][0][:ability]).to be_a(Ability)
        expect(report[:header][0][:user]).to be_a(Ability::TestUser)
        expect(report.dig(:data, "Alles", "Beheren")).to eq([true, true, false, false, false, false, false, false, false])
        expect(report.dig(:data, "Werk", "Bewerk locatie")).to eq([true, true, true, false, true, true, true, false, false])
      end
    end
  end

  describe "#viewable_work_fields" do
    it "returns all fields in DISPLAYED_PROPERTIES for admin" do
      ability = Ability.new(users(:admin))
      not_returned = Work::ParameterRendering::DISPLAYED_PROPERTIES - ability.viewable_work_fields
      expect(not_returned).to eq([])
    end
  end
end
