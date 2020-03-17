# frozen_string_literal: true

require "rails_helper"

RSpec.describe "frame_types/show", type: :view do
  before(:each) do
    @frame_type = assign(:frame_type, FrameType.create!(
      name: "Name",
      hide: false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/false/)
  end
end
