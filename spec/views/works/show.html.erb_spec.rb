require 'rails_helper'

RSpec.describe "works/show", type: :view do
  include Devise::Test::ControllerHelpers

  before(:each) do
    @collection = collections(:collection1)
    @selection = {display: :complete}
    @work = assign(:work, Work.create!(
      title: "Work",
      alt_number_1: "aul07<script>alert(1)</script>kviak",
      alt_number_2: "aul07<script>alert(1)</script>kviak",
      alt_number_3: "aul07<script>alert(1)</script>kviak",
      description:  "aul07<script>alert(1)</script>kviak",
      information_back: "aul07<script>alert(1)</script>kviak",
      medium_comments:  "aul07<script>alert(1)</script>kviak",
      print: "aul07<script>alert(1)</script>kviak",
      signature_comments: "aul07<script>alert(1)</script>kviak",
      collection: @collection
    ))
  end

  it "renders attributes in <p>" do
    user = users(:admin)
    sign_in user

    render
    expect(rendered).not_to match(/<script>alert\(1\)<\/script>/)
    expect(rendered).to match(/aul07alert\(1\)kviak/)
  end
end
