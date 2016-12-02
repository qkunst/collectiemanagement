require 'rails_helper'

RSpec.describe "messages/index", type: :view do
  before(:each) do
    assign(:messages, [
      Message.create!(
        :from_user_id => 1,
        :to_user_id => 2,
        :in_reply_to_message_id => 3,
        :qkunst_private => false,
        :conversation_start_message_id => 4,
        :subject => "Subject",
        :message => "MyText",
        :subject_url => "MyText",
        :just_a_note => false,
        :image => "Image"
      ),
      Message.create!(
        :from_user_id => 1,
        :to_user_id => 2,
        :in_reply_to_message_id => 3,
        :qkunst_private => false,
        :conversation_start_message_id => 4,
        :subject => "Subject",
        :message => "MyText",
        :subject_url => "MyText",
        :just_a_note => false,
        :image => "Image"
      )
    ])
  end

  it "renders a list of messages" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => "Subject".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Image".to_s, :count => 2
  end
end
