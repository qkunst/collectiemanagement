require 'rails_helper'

RSpec.describe Attachment, type: :model do
  describe "Class methods" do
  end
  describe "Scopes" do
    describe "for_me" do
      it "should always work for admin" do
        admin = users(:admin)
        a = Attachment.create(file: File.open('Gemfile'))
        expect(Attachment.for_me(admin)).to include(a)
      end
    end
  end
end
