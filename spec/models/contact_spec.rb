require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe "#name" do
    it "returns external contact if type is external" do
      expect(Contact.new(external:true).name).to eq("External")
    end

    it "returns name when set, even if type is external" do
      expect(Contact.new(external:true, name: "Real name").name).to eq("Real name")
    end

    it "can save without an name when external" do
      c = Contact.create(collection: collections(:collection1))
      expect(c).not_to be_valid
      c = Contact.create(name: "Transporter A", collection: collections(:collection1))
      expect(c).to be_valid
      c = Contact.create(external: true, collection: collections(:collection1), url: "https://uitleen/contacts/uuid")
      expect(c).to be_valid
    end
  end
end
