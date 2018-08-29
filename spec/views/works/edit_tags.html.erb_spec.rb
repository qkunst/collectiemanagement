require 'rails_helper'

RSpec.describe "works/edit_tags", type: :view do
  include Devise::Test::ControllerHelpers

  it "allows_to_edit_tags" do
    @collection = collections(:collection1)
    @selection = {display: :complete}
    @work = assign(:work, works(:work1))
    sign_in users(:admin)
    render
    expect(rendered).to match(/Beheer tags/)
  end

end
