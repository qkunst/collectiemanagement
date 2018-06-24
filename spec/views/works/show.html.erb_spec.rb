require 'rails_helper'

RSpec.describe "works/show", type: :view do
  include Devise::Test::ControllerHelpers

  it "renders attributes in <p>" do
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
    sign_in users(:admin)
    @custom_reports = []
    render
    expect(rendered).not_to match(/<script>alert\(1\)<\/script>/)
    expect(rendered).to match(/aul07alert\(1\)kviak/)
  end

  it "renders attachments" do
    @collection = collections(:collection1)
    @selection = {display: :complete}
    @work = works(:work_with_attachments)
    @custom_reports = []
    sign_in users(:admin)

    render
    expect(rendered).to match(/Work with attachment/)
    expect(rendered).to match(/unpredictableattachmentname/)
  end
end
