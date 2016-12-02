require 'rails_helper'

RSpec.describe "messages/new", type: :view do
  before(:each) do
    assign(:message, Message.new(
      :from_user_id => 1,
      :to_user_id => 1,
      :in_reply_to_message_id => 1,
      :qkunst_private => false,
      :conversation_start_message_id => 1,
      :subject => "MyString",
      :message => "MyText",
      :subject_url => "MyText",
      :just_a_note => false,
      :image => "MyString"
    ))
  end

  it "renders new message form" do
    render

    assert_select "form[action=?][method=?]", messages_path, "post" do

      assert_select "input#message_from_user_id[name=?]", "message[from_user_id]"

      assert_select "input#message_to_user_id[name=?]", "message[to_user_id]"

      assert_select "input#message_in_reply_to_message_id[name=?]", "message[in_reply_to_message_id]"

      assert_select "input#message_qkunst_private[name=?]", "message[qkunst_private]"

      assert_select "input#message_conversation_start_message_id[name=?]", "message[conversation_start_message_id]"

      assert_select "input#message_subject[name=?]", "message[subject]"

      assert_select "textarea#message_message[name=?]", "message[message]"

      assert_select "textarea#message_subject_url[name=?]", "message[subject_url]"

      assert_select "input#message_just_a_note[name=?]", "message[just_a_note]"

      assert_select "input#message_image[name=?]", "message[image]"
    end
  end
end
