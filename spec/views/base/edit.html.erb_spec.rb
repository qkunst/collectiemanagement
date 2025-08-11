# frozen_string_literal: true

require "rails_helper"

RSpec.describe "base/edit", type: :view do
  before(:each) do
    @subject = assign(:subject, FrameType.create!(
      name: "MyString",
      hide: false
    ))
  end

  it "renders the edit frame_type form" do
    render(locals: {controlled_class: FrameType})

    assert_select "form[action=?][method=?]", frame_type_path(@subject), "post" do
      assert_select "input#frame_type_name[name=?]", "frame_type[name]"

      assert_select "input#frame_type_hide[name=?]", "frame_type[hide]"
    end
  end
end
