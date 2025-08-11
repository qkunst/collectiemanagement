# frozen_string_literal: true

require "rails_helper"

RSpec.describe "base/new", type: :view do
  before(:each) do
    assign(:subject, FrameType.new(
      name: "MyString",
      hide: false
    ))
  end

  it "renders new frame_type form" do
    render(locals: {controlled_class: FrameType})

    assert_select "form[action=?][method=?]", frame_types_path, "post" do
      assert_select "input#frame_type_name[name=?]", "frame_type[name]"

      assert_select "input#frame_type_hide[name=?]", "frame_type[hide]"
    end
  end
end
