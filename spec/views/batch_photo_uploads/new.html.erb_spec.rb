require 'rails_helper'

RSpec.describe "batch_photo_uploads/new", type: :view do
  before(:each) do
    assign(:batch_photo_upload, BatchPhotoUpload.new(
      :zip_file => "MyString",
      :images => "MyText",
      :collection_id => 1,
      :settings => "MyText"
    ))
  end

  it "renders new batch_photo_upload form" do
    render

    assert_select "form[action=?][method=?]", batch_photo_uploads_path, "post" do

      assert_select "input#batch_photo_upload_zip_file[name=?]", "batch_photo_upload[zip_file]"

      assert_select "textarea#batch_photo_upload_images[name=?]", "batch_photo_upload[images]"

      assert_select "input#batch_photo_upload_collection_id[name=?]", "batch_photo_upload[collection_id]"

      assert_select "textarea#batch_photo_upload_settings[name=?]", "batch_photo_upload[settings]"
    end
  end
end
