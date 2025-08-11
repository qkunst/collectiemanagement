# frozen_string_literal: true

require "rails_helper"

RSpec.describe "base/show", type: :view do
  before(:each) do
    @subject = assign(:frame_type, FrameType.create!(
      name: "Een bijzonder Frame Type",
      hide: false
    ))
  end

  it "renders attributes" do
    render(locals: {controlled_class: FrameType})
    expect(rendered).to match(/Een bijzonder Frame Type/)
    expect(rendered).not_to match(/verborgen/)
  end

  it "shows that it is hidden when hidden" do
    @subject.hide = true
    render(locals: {controlled_class: FrameType})
    expect(rendered).to match(/Een bijzonder Frame Type/)
    expect(rendered).to match(/verborgen/)
  end
end
