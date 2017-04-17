require 'rails_helper'

RSpec.describe "frame_types/index", type: :view do
  before(:each) do
    assign(:frame_types, [
      FrameType.create!(
        :name => "Name",
        :hide => false
      ),
      FrameType.create!(
        :name => "Name",
        :hide => false
      )
    ])
  end

  it "renders a list of frame_types" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
