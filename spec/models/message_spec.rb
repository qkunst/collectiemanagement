require 'rails_helper'

RSpec.describe Message, type: :model do
  describe "#notifyable_users" do
    it "should return current_users" do
      u1 = users(:user1)
      u2 = users(:user2)
      u3 = users(:user3)
      m = Message.new(from_user: u1, to_user: u2)
      expect(m.notifyable_users).to include(u2)
      expect(m.notifyable_users).not_to include(u3)
      expect(m.notifyable_users).to include(users(:admin))
    end
    it "should return conversation users" do
      u1 = users(:user1)
      u2 = users(:user2)
      u3 = users(:user3)
      m = Message.create(from_user: u1, to_user: u2, subject: "sub", message: "messss")
      m2 = Message.create(from_user: u2, to_user: u3, subject: "sub", message: "messss", in_reply_to_message: m)
      expect(m2.notifyable_users).not_to include(u2)
      expect(m2.notifyable_users).to include(u3)
      expect(m2.notifyable_users).to include(u1)
      expect(m2.notifyable_users).to include(users(:admin))
    end
    it "should return conversation users" do
      u1 = users(:user1)
      u2 = users(:user2)
      u3 = users(:user3)
      m = Message.new(from_user: u1, to_user: u2, subject: "sub", message: "messss", qkunst_private: true)
      expect(m.notifyable_users).not_to include(u2)
      expect(m.notifyable_users).not_to include(u3)
      expect(m.notifyable_users).not_to include(u1)
      expect(m.notifyable_users).to include(users(:admin))
    end
  end
end
