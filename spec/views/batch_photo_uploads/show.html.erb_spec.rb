require 'rails_helper'

RSpec.describe "batch_photo_uploads/show", type: :view do
  before(:each) do
    @batch_photo_upload = assign(:batch_photo_upload, BatchPhotoUpload.create!(
      :zip_file => "Zip File",
      :images => "MyText",
      :collection_id => 1,
      :settings => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Zip File/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/MyText/)
  end
end
