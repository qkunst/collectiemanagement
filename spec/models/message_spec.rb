require 'rails_helper'

RSpec.describe Message, type: :model do
  describe "methods" do
    describe "set_from_user_name!" do
      it "should set on save" do
        u1 = users(:user1)
        u2 = users(:user2)
        m = Message.new(from_user: u1, to_user: u2)
        m.save
        expect(m.from_user_name).to eq(u1.name.to_s)
      end
    end
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
      it "should return only qkunst admin when private" do
        u1 = users(:user1)
        u2 = users(:user2)
        u3 = users(:user3)
        m = Message.new(from_user: u1, to_user: u2, subject: "sub", message: "messss", qkunst_private: true)
        expect(m.notifyable_users).not_to include(u2)
        expect(m.notifyable_users).not_to include(u3)
        expect(m.notifyable_users).not_to include(u1)
        expect(m.notifyable_users).to include(users(:admin))
      end
      it "should return only admin when qkunst private and no to user" do
        u1 = users(:user1)
        u2 = users(:user2)
        u3 = users(:user3)
        m = Message.new(from_user: u1, subject: "sub", message: "messss", qkunst_private: true)
        expect(m.notifyable_users).not_to include(u2)
        expect(m.notifyable_users).not_to include(u3)
        expect(m.notifyable_users).not_to include(u1)
        expect(m.notifyable_users).to include(users(:admin))
      end
    end
  end
  describe "scopes" do
    describe "sent_at_date" do
      it "should work" do
        u1 = users(:user1)
        u2 = users(:user2)
        u3 = users(:user3)
        m = Message.create(from_user: u1, to_user: u2, subject: "sub", message: "messss")
        p m.inspect.gsub("<","")
        p m.errors
        m2 = Message.create(from_user: u2, to_user: u3, subject: "sub", message: "messss", in_reply_to_message: m)
        expect(Message.sent_at_date(Time.now.to_date).count).to eq(2)
        expect(Message.sent_at_date(Time.now.to_date+1.day).count).to eq(0)
      end
    end
    describe "thread_can_be_accessed_by_user" do
      it "should work" do
        u1 = users(:user1)
        u2 = users(:user2)
        u3 = users(:user3)
        m = Message.create(from_user: u1, to_user: u2, subject: "sub", message: "messss")
        expect(Message.thread_can_be_accessed_by_user(u1)).to include(m)
        expect(Message.thread_can_be_accessed_by_user(u2)).to include(m)
        expect(Message.thread_can_be_accessed_by_user(u3)).not_to include(m)
        m2 = Message.create(from_user: u2, to_user: u3, subject: "sub", message: "messss", in_reply_to_message: m)
        expect(Message.thread_can_be_accessed_by_user(u1)).to include(m2)
        expect(Message.thread_can_be_accessed_by_user(u2)).to include(m2)
        expect(Message.thread_can_be_accessed_by_user(u3)).to include(m2)
      end
    end
  end
end
