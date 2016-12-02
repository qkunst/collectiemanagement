require 'rails_helper'

RSpec.describe "batch_photo_uploads/index", type: :view do
  before(:each) do
    assign(:batch_photo_uploads, [
      BatchPhotoUpload.create!(
        :zip_file => "Zip File",
        :images => "MyText",
        :collection_id => 1,
        :settings => "MyText"
      ),
      BatchPhotoUpload.create!(
        :zip_file => "Zip File",
        :images => "MyText",
        :collection_id => 1,
        :settings => "MyText"
      )
    ])
  end

  it "renders a list of batch_photo_uploads" do
    render
    assert_select "tr>td", :text => "Zip File".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
