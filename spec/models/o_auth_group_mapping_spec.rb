# == Schema Information
#
# Table name: o_auth_group_mappings
#
#  id            :integer          not null, primary key
#  issuer        :string
#  value_type    :string
#  value         :string
#  collection_id :integer
#  role          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require "rails_helper"

RSpec.describe OAuthGroupMapping, type: :model do
  describe ".for [QSECIMP0003]" do
    it "returns nothing when data is empty" do
      expect(OAuthGroupMapping.for(Users::OmniauthCallbackData.new)).to eq([])
    end

    it "returns relevant when existing" do
      expect(OAuthGroupMapping.for(Users::OmniauthCallbackData.new(roles: ["a", "jfjfjk"], issuer: "microsoft/abc")).count).to eq(1)
    end
  end
  describe ".role_mappings_exists_for? [QSECIMP0004]" do
    it "returns false when none" do
      expect(OAuthGroupMapping.role_mappings_exists_for?("google")).to be_falsey
    end
    it "returns false when none" do
      expect(OAuthGroupMapping.role_mappings_exists_for?("microsoft/abc")).to be_truthy
    end
  end
  describe ".collection_mappings_exists_for?" do
    it "returns false when none" do
      expect(OAuthGroupMapping.collection_mappings_exists_for?("google")).to be_falsey
    end
    it "returns false when none" do
      expect(OAuthGroupMapping.collection_mappings_exists_for?("microsoft/abc")).to be_truthy
    end
  end
  describe ".create" do
    it "creates with valid data" do
      expect {
        OAuthGroupMapping.create(issuer: "trustworthytenant", value_type: :group, value: "collection1", collection_id: collections(:collection1).id, role: :facility_manager)
      }.to change(OAuthGroupMapping, :count).by(1)
    end
  end
end
