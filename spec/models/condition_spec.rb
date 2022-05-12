# frozen_string_literal: true

# == Schema Information
#
# Table name: conditions
#
#  id         :bigint           not null, primary key
#  hide       :boolean          default(FALSE)
#  name       :string
#  order      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "rails_helper"

RSpec.describe Condition, type: :model do
  describe "class methods" do
    describe ".find_by_name" do
      it "should work" do
        expect(Condition.find_by_name("Goed")).to eq(conditions(:goed))
      end
    end
  end
end
