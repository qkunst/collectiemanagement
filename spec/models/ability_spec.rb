# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ability, type: :model do
  example_groups = {
    :advisor => {
      "Alias workings" => [
        [:manage_collection, :collection, :collection_with_works, true],
        [:review_collection, :collection, :collection_with_works, true],
      ]
    },
    :compliance => {
      "Collections" => [
        [:read, :collection, :collection_with_works, true],
        [:read, :collection, :collection3, false],
        [:manage_collection, :collection, :collection_with_works, false],
        [:review_collection, :collection, :collection_with_works, true],
        [:read_extended_report, :collection, :collection_with_works, true],
      ],
      "Works" => [
        [:read, :work, :work1, true],
        [:edit, :work, :work1, false],
        [:edit_location, :work, :work1, false],
        [:read, :work, :work6, false],
        [:show_details, :work, :work1, true],
      ],
    },
    :appraiser => {
      "Collections" => [
        [:read, :collection, :collection_with_works, true],
        [:read, :collection, :collection3, false],
        [:manage_collection, :collection, :collection_with_works, false],
        [:review_collection, :collection, :collection_with_works, false],
        [:read_report, :collection, :collection_with_works, true],
        [:read_extended_report, :collection, :collection_with_works, true],
      ],
      "Works" => [
        [:read, :work, :work1, true],
        [:edit, :work, :work1, true],
        [:edit_location, :work, :work1, true],
        [:read, :work, :work6, false],
        [:show_details, :work, :work1, true],
      ],
    },
    :facility_manager => {
      "Collections" => [
        [:read, :collection, :collection_with_works, true],
        [:read, :collection, :collection3, false],
        [:manage_collection, :collection, :collection_with_works, false],
        [:review_collection, :collection, :collection_with_works, false],
        [:read_report, :collection, :collection_with_works, true],
        [:read_extended_report, :collection, :collection_with_works, false],
      ],
      "Works" => [
        [:read, :work, :work1, true],
        [:edit, :work, :work1, false],
        [:edit_location, :work, :work1, true],
        [:read, :work, :work6, false],
        [:show_details, :work, :work1, true],
      ],
    }
  }



  example_groups.each do |k1, v1|
    context k1 do
      let(:user) { Ability.new(users(k1))}
      v1.each do |k2, v2|
        describe k2 do
          v2.each do |v3|
            it "#{v3[3] ? 'can' : 'cannot'} #{v3[0]} #{v3[1]}(:#{v3[2]})" do
              test_obj = self.send(v3[1].to_s.pluralize.to_sym, v3[2])
              expect(user.can? v3[0], test_obj).to eq(v3[3])
            end
          end
        end
      end
    end
  end



end