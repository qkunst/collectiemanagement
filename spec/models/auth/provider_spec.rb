# == Schema Information
#
# Table name: auth_providers
#
#  id         :integer          not null, primary key
#  strategy   :string
#  client_id  :string
#  secret     :string
#  options    :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  uuid       :string
#
# Indexes
#
#  index_auth_providers_on_client_id_and_strategy  (client_id,strategy)
#  index_auth_providers_on_uuid                    (uuid)
#

require "rails_helper"

RSpec.describe Auth::Provider, type: :model do
  let(:default_attributes) do
    {
      strategy: "oauth",
      client_id: "my-client-123",
      secret: "super-secret-key",
      options: {scope: "user:read"}
    }
  end
  let(:attributes) { default_attributes }
  subject { described_class.create(attributes) }

  describe "validations" do
    context "presence validations" do
      it "is valid with all required attributes present" do
        expect(subject).to be_valid
      end

      it "is invalid when strategy is blank" do
        subject.strategy = nil
        expect(subject).not_to be_valid
        expect(subject.errors[:strategy]).to include("moet opgegeven zijn")
      end

      it "is invalid when client_id is blank" do
        subject.client_id = nil
        expect(subject).not_to be_valid
        expect(subject.errors[:client_id]).to include("moet opgegeven zijn")
      end
    end

    context "uniqueness validations" do
      it "is invalid when provider is duplicated" do
        subject
        duplicate = subject.dup
        duplicate.uuid = nil

        expect(duplicate).to be_invalid
      end

      it "is valid when provider is updated" do
        subject
        duplicate = subject.dup
        duplicate.uuid = nil
        duplicate.client_id = "something_else"

        expect(duplicate).to be_valid
      end
    end
  end
end
