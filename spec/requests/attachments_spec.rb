# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Attachments", type: :request do
  include ActionDispatch::TestProcess::FixtureFile
  include Rack::Test::Methods

  let(:collection) { collections(:collection1) }

  describe "GET /attachments/new" do
    it "redirects by default" do
      get new_collection_attachment_path(collection)
      expect(last_response.redirect?).to be_truthy
    end
    it "redirects by default when not qkunst" do
      sign_in users(:read_only)
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
    it "succeeds when registrator" do
      sign_in users(:registrator)
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

    it "lists no accessible attachments if none" do
      sign_in users(:appraiser)

      work_with_attachment = works(:work_with_attachments)

      get collection_work_attachments_path(work_with_attachment.collection, work_with_attachment)
      expect(last_response.ok?).to be_truthy

      expect(last_response.body).to match(/<tbody>\s*<\/tbody>/)
    end

    it "lists  accessible attachments if some" do
      user = users(:appraiser)
      sign_in user

      work_with_attachment = works(:work_with_attachments)

      work_with_attachment.attachments.each { |a| a.update_columns(visibility: "facility_manager,appraiser,compliance") }

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
      it "stores an attachment on collection level as registrator" do
        sign_in users(:registrator)
        image_name = "#{SecureRandom.uuid}.jpg"

        expect {
          file = fixture_file_upload("image.jpg", "image/jpeg", :binary)
          post collection_attachments_path(collection_id: collection.id), {attachment: {file: file, name: image_name, visibility: [:admin, :qkunst]}}
        }.to change(Attachment, :count).by(1)

        attachment = Attachment.find_by_name(image_name)
        expect(attachment.collection).to eq(collection)
        expect(attachment.works).to eq([])
      end
      it "attaches to a base collection when set" do
        non_base_collection = collections(:collection_with_stages_child)
        non_base_collection_base_collection = collections(:collection_with_stages)

        expect(non_base_collection.base_collection).to eq(non_base_collection_base_collection)

        image_name = "#{SecureRandom.uuid}.jpg"

        sign_in users(:admin)
        expect {
          file = fixture_file_upload("image.jpg", "image/jpeg", :binary)
          post collection_attachments_path(collection_id: non_base_collection.id), {attachment: {file: file, name: image_name, visibility: [:admin]}}
        }.to change(Attachment, :count).by(1)

        attachment = Attachment.find_by_name(image_name)
        expect(attachment.collection).to eq(non_base_collection_base_collection)
      end
    end
  end

  describe "DELETE /attachment/:id" do
    let(:attachment) { attachments(:work_attachment) }

    context "collection" do
      it "destroys" do
        sign_in users(:admin)
        expect {
          delete collection_attachment_path(attachment.collection, attachment)
        }.to change(Attachment, :count).by(-1)
      end
      it "doesn't destroy as registrator" do
        sign_in users(:registrator)
        expect {
          delete collection_attachment_path(attachment.collection, attachment)
        }.not_to change(Attachment, :count)
      end
    end

    context "collection" do
      it "destroys" do
        sign_in users(:admin)
        expect {
          delete collection_attachment_path(attachment.collection, attachment)
        }.to change(Attachment, :count).by(-1)
      end
    end

    context "work" do
      it "removes at work" do
        sign_in users(:admin)

        work = attachment.works.first

        expect {
          delete collection_work_attachment_path(work.collection, work, attachment)
        }.not_to change(Attachment, :count)

        work.reload
        expect(work.attachments).not_to include(attachment)
      end
    end
  end

  describe "PATCH /attachment/:id" do
    let(:current_visibility) { ["qkunst", "admin"] }
    let(:attachment) { collections(:collection1).attachments.create(file: File.open("Gemfile"), visibility: current_visibility) }
    let(:new_visibility) { ["qkunst", "admin", "appraiser"] }
    let(:update_visibility) { patch(collection_attachment_path(attachment.collection, attachment), {attachment: {visibility: new_visibility}}) }

    context "collection" do
      it "as admin it should update visibility" do
        sign_in users(:admin)
        update_visibility
        attachment.reload

        expect(attachment.visibility).to eq(new_visibility)
      end
      it "as registrator it should not update visibility" do
        sign_in users(:registrator)

        update_visibility

        attachment.reload

        expect(attachment.visibility).to eq(current_visibility)
      end
    end
  end
end
