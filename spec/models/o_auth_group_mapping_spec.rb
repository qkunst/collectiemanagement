require 'rails_helper'

RSpec.describe OAuthGroupMapping, type: :model do
  describe ".for" do
    it "returns nothing when data is empty" do
      expect(OAuthGroupMapping.for(Users::OmniauthCallbackData.new)).to eq([])
    end

    it "returns relevant when existing" do
      expect(OAuthGroupMapping.for(Users::OmniauthCallbackData.new(roles: ["a", "jfjfjk"], issuer: "microsoft/abc")).count).to eq(1)
    end
  end
  describe ".role_mappings_exists_for?" do
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
end
