# frozen_string_literal: true

# == Schema Information
#
# Table name: messages
#
#  id                               :bigint           not null, primary key
#  actioned_upon_by_qkunst_admin_at :datetime
#  attachment                       :string
#  from_user_name                   :string
#  image                            :string
#  just_a_note                      :boolean
#  message                          :text
#  qkunst_private                   :boolean
#  subject                          :string
#  subject_object_type              :string
#  subject_url                      :text
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  conversation_start_message_id    :bigint
#  from_user_id                     :bigint
#  in_reply_to_message_id           :bigint
#  reminder_id                      :bigint
#  subject_object_id                :bigint
#  to_user_id                       :bigint
#
require "rails_helper"

RSpec.describe Message, type: :model do
  describe "callbacks" do
    it "should not mark initial message as actioned upon when not qkunst" do
      m_o = Message.create(from_user: users(:user1), message: "abc", subject: "abc")
      expect(m_o.actioned_upon_by_qkunst_admin?).to eq(false)
      Message.create(in_reply_to_message_id: m_o.id, from_user: users(:user1), message: "abc")
      m_o.reload
      expect(m_o.actioned_upon_by_qkunst_admin?).to eq(false)
    end
    it "should not mark initial message as actioned upon when qkunst" do
      m_o = Message.create(from_user: users(:user1), message: "abc", subject: "abc")
      expect(m_o.actioned_upon_by_qkunst_admin?).to eq(false)
      Message.create(in_reply_to_message_id: m_o.id, from_user: users(:advisor), message: "abc")
      m_o.reload
      expect(m_o.actioned_upon_by_qkunst_admin?).to eq(true)
    end
  end
  describe "methods" do
    describe "set_from_user_name!" do
      it "should set on save" do
        u1 = users(:user1)
        u2 = users(:user2)
        m = Message.new(from_user: u1, to_user: u2, message: "abc", subject: "abc")
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
        expect(m.notifyable_users).not_to include(users(:admin))
      end
      it "should return also not email receiving users with direct reply" do
        u1 = users(:user1)
        u2 = users(:user2)
        u3 = users(:user3)
        u2.update(receive_mails: false)
        m = Message.new(from_user: u1, to_user: u2)
        expect(m.notifyable_users).to include(u2)
        expect(m.notifyable_users).not_to include(u3)
        expect(m.notifyable_users).not_to include(users(:admin))
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
        expect(m2.notifyable_users).not_to include(users(:admin))
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
    describe "#attachment" do
      it "accepts attachment" do
        file = File.open("Gemfile")
        u1 = users(:user1)

        m = Message.new(from_user: u1, subject: "sub", message: "messss", qkunst_private: true, attachment: file)
        m.save

        expect(m.attachment.file.path).to match("uploads/message/attachment")
      end
    end
  end
  describe "scopes" do
    describe ".sent_at_date" do
      it "should work" do
        u1 = users(:user1)
        u2 = users(:user2)
        u3 = users(:user3)
        Message.destroy_all
        m = Message.create(from_user: u1, to_user: u2, subject: "sub", message: "messss")
        Message.create(from_user: u2, to_user: u3, subject: "sub", message: "messss", in_reply_to_message: m)
        expect(Message.sent_at_date(Time.now.to_date).count).to eq(2)
        expect(Message.sent_at_date(Time.now.to_date + 1.day).count).to eq(0)
      end
    end
    describe "thread_can_be_accessed_by_user" do
      it "should show the thread to participating users" do
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
      it "should show the thread to facility managers in same org" do
        fm1 = users(:facility_manager_collection3)
        fm2 = users(:facility_manager_two_collection3)
        m = messages(:conversation_starter_collection3)

        expect(Message.thread_can_be_accessed_by_user(fm1)).to include(m)
        expect(Message.thread_can_be_accessed_by_user(fm2)).to include(m)
      end
      it "should block facility user from accessing messages from other collections" do
        facility_manager = users(:facility_manager)
        expect(facility_manager.accessible_collections).not_to include(collections(:collection3))

        collection_3_message = collections(:collection3).messages.first

        expect(Message.thread_can_be_accessed_by_user(facility_manager)).not_to include(collection_3_message)
      end
    end
    describe "collections" do
      it "should not contain messages with another collection message subject" do
        expect(Message.collections([collections(:collection2)])).not_to include(messages(:conversation_starter_about_collection_with_works))
        expect(Message.collections([collections(:collection2)])).not_to include(messages(:conversation_reply))
      end
      it "should include message about a collection's work" do
        expect(Message.collections([collections(:collection_with_works)])).to include(messages(:conversation_starter_about_collection_with_works))
        expect(Message.collections([collections(:collection_with_works)])).not_to include(messages(:conversation_starter))
        expect(Message.collections([collections(:collection_with_works)])).to include(messages(:conversation_starter_about_work))
      end

      it "should include messages about child collections (and works in those)" do
        expect(Message.collections([collections(:collection1)])).to include(messages(:conversation_starter_about_collection_with_works))
        expect(Message.collections([collections(:collection1)])).to include(messages(:conversation_starter))
        expect(Message.collections([collections(:collection1)])).to include(messages(:conversation_starter_about_work))
      end
    end
    describe ".limit_age_to" do
      it "should limit to last year" do
        expect(Message.limit_age_to.count).to eq(Message.count - 1)
      end
      it "accepts overrrides" do
        expect(Message.limit_age_to(1000.years).count).to eq(Message.count)
      end
    end
  end
end
