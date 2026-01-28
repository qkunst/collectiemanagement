require "rails_helper"

RSpec.describe User::Issuer, type: :model do
  subject(:user_issuer) { described_class.new(issuer) }

  let(:issuer) { "microsoft/abc" }
  let(:role_mapping_fm) { o_auth_group_mappings(:microsoft_abc_fm) }
  let(:role_mapping_adv) { o_auth_group_mappings(:microsoft_abc_adv) }
  let(:collection_mapping) { o_auth_group_mappings(:microsoft_abc_collection_1) }

  let!(:other_issuer_mapping) do
    OAuthGroupMapping.create!(
      issuer: "google/xyz",
      value_type: "role",
      value: "external-role",
      role: "advisor"
    )
  end

  describe "#oauth_group_mappings" do
    it "returns only mappings for the configured issuer" do
      expect(user_issuer.oauth_group_mappings).to match_array(
        [role_mapping_fm, role_mapping_adv, collection_mapping]
      )
      expect(user_issuer.oauth_group_mappings).not_to include(other_issuer_mapping)
    end
  end

  describe "#role_mappings" do
    it "filters mappings to those that include a role" do
      expect(user_issuer.role_mappings).to match_array(
        [role_mapping_fm, role_mapping_adv]
      )
    end
  end

  describe "#collection_mappings" do
    it "filters mappings to those that include a collection" do
      expect(user_issuer.collection_mappings).to contain_exactly(collection_mapping)
    end
  end

  describe "#role_mappings?" do
    context "when the issuer has role mappings" do
      it "returns true" do
        expect(user_issuer.role_mappings?).to be(true)
      end
    end

    context "when the issuer has no role mappings" do
      it "returns false" do
        expect(described_class.new("unknown/issuer").role_mappings?).to be(false)
      end
    end
  end

  describe "#collection_mappings?" do
    context "when the issuer has collection mappings" do
      it "returns true" do
        expect(user_issuer.collection_mappings?).to be(true)
      end
    end

    context "when the issuer has no collection mappings" do
      it "returns false" do
        expect(described_class.new("unknown/issuer").collection_mappings?).to be(false)
      end
    end
  end
end
