# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Attachments", type: :request do
  include Rack::Test::Methods

  let(:collection) { collections(:collection1) }

  describe "GET /attachments/new" do
    it "redirects by default" do
      get new_collection_attachment_path(collection)
      expect(last_response.redirect?).to be_truthy
    end
    it "redirects by default when not qkunst" do
      sign_in users(:read_only_user)
      get new_collection_attachment_path(collection)
      expect(last_response.redirect?).to be_truthy
    end
    it "redirects by default when not qkunst (fm)" do
      sign_in users(:facility_manager)
      get new_collection_attachment_path(collection)
      expect(last_response.redirect?).to be_truthy
    end
    it "redirects by default when qkunst without access" do
      sign_in users(:qkunst)
      get new_collection_attachment_path(collection)
      expect(last_response.redirect?).to be_truthy
    end
    it "success when qkunst with acces" do
      sign_in users(:qkunst_with_collection)
      get new_collection_attachment_path(collection)
      expect(last_response.ok?).to be_truthy
    end
    it "success when admin" do
      sign_in users(:admin)
      get new_collection_attachment_path(collection)
      expect(last_response.ok?).to be_truthy
    end
  end

  describe "GET /attachments" do
    it "lists no attachments if none" do
      sign_in users(:appraiser)

      work_without_attachment = works(:work6)

      get collection_work_attachments_path(work_without_attachment.collection, work_without_attachment)
      expect(last_response.ok?).to be_truthy

      expect(last_response.body).to match(/<tbody>\s*<\/tbody>/)
    end

    it "lists no attachments if none" do
      sign_in users(:appraiser)

      work_with_attachment = works(:work_with_attachments)

      get collection_work_attachments_path(work_with_attachment.collection, work_with_attachment)
      expect(last_response.ok?).to be_truthy

      expect(last_response.body).not_to match(/<tbody>\s*<\/tbody>/)
      expect(last_response.body).to match(/unpredictableattachmentname/)
    end
  end

  describe "POST /attachments" do
    context "work" do
      let(:work) { works(:work1) }
      let(:collection) { work.collection }

      it "stores an attachment on work level" do
        sign_in users(:admin)
        image_name = "#{SecureRandom.uuid}.jpg"

        expect {
          file = fixture_file_upload("image.jpg", "image/jpeg", :binary)
          post collection_work_attachments_path(collection, work), {attachment: {file: file, name: image_name, visibility: [:admin]}}
        }.to change(Attachment, :count).by(1)

        attachment = Attachment.find_by_name(image_name)
        expect(last_response.location).to end_with(collection_work_path(collection, work))

        expect(attachment.collection).to eq(collection)
        expect(attachment.works).to eq([work])
      end
    end

    context "collection" do
      it "stores an attachment on collection level" do
        sign_in users(:admin)
        image_name = "#{SecureRandom.uuid}.jpg"

        expect {
          file = fixture_file_upload("image.jpg", "image/jpeg", :binary)
          post collection_attachments_path(collection_id: collection.id), {attachment: {file: file, name: image_name, visibility: [:admin]}}
        }.to change(Attachment, :count).by(1)

        attachment = Attachment.find_by_name(image_name)
        expect(attachment.collection).to eq(collection)
        expect(attachment.works).to eq([])
      end
    end
  end
end
