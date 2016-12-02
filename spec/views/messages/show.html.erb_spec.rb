require 'rails_helper'

RSpec.describe "messages/show", type: :view do
  before(:each) do
    @message = assign(:message, Message.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/Subject/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Image/)
  end
end
