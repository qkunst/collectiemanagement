require 'rails_helper'

RSpec.describe "frame_types/edit", type: :view do
  before(:each) do
    @frame_type = assign(:frame_type, FrameType.create!(
      :name => "MyString",
      :hide => false
    ))
  end

  it "renders the edit frame_type form" do
    render

    assert_select "form[action=?][method=?]", frame_type_path(@frame_type), "post" do

      assert_select "input#frame_type_name[name=?]", "frame_type[name]"

      assert_select "input#frame_type_hide[name=?]", "frame_type[hide]"
    end
  end
end
