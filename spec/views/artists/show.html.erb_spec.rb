require 'rails_helper'

RSpec.describe "artists/show", type: :view do
  include Devise::Test::ControllerHelpers

  before(:each) do
    @artist = assign(:artist, Artist.create!(
      description: "aul07<script>alert(1)</script>kviak",
    ))
    @works = []
  end

  it "renders attributes in <p>" do
    user = users(:admin)
    sign_in user

    render
    expect(rendered).not_to match(/<script>alert\(1\)<\/script>/)
    expect(rendered).to match(/aul07alert\(1\)kviak/)
  end
end
