# == Schema Information
#
# Table name: organisations
#
#  id               :integer          not null, primary key
#  domains          :json
#  auth_provider_id :integer
#  name             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_organisations_on_auth_provider_id  (auth_provider_id)
#

require 'rails_helper'

RSpec.describe Organisation, type: :model do
  describe "scopes" do
    describe ".for_domain" do
      it "returns organisations with the matching domain" do
        expect(Organisation.for_domain("murb.nl").to_a).to include(organisations(:murb_org))
        expect(Organisation.for_domain("murb.nl").to_a).not_to include(organisations(:qkunst_org))
      end

      it "returns organisations with the domain even when multiple domains are present" do
        expect(Organisation.for_domain("example.org").to_a).to include(organisations(:multi_domain_org))
        expect(Organisation.for_domain("example.com").to_a).to include(organisations(:multi_domain_org))
      end

      it "returns no organisations when the domain does not match" do
        expect(Organisation.for_domain("nonexistent.org").to_a).to be_empty
      end

      it "returns no organisations for an organisation with empty domains" do
        expect(Organisation.for_domain("any.com").to_a).not_to include(organisations(:no_domain_org))
      end
    end
  end
end
