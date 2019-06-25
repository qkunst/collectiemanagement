# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UnsecureTmpBasicPictureUploader, type: :model do
  describe  "callbacks" do
  end

  describe "instance methods" do
    describe "#work" do
      it "returns nil by default" do
        uploader = UnsecureTmpBasicPictureUploader.new(batch_photo_uploads(:batch_photo_upload1))
        expect(uploader).to receive(:filename).and_return("random file name.jpg").exactly(3).times
        expect(uploader.work).to eq nil
      end

      it "returns a work when it matches a work id" do
        uploader = UnsecureTmpBasicPictureUploader.new(batch_photo_uploads(:batch_photo_upload1))
        expect(uploader).to receive(:filename).and_return("Q001.jpg").exactly(3).times
        expect(uploader.work).to eq works(:work1)
      end

      ["Q001-back.jpg", "Q001-front", "Q001-voorkant", "Q001 voor"].each do |filename|
        it "returns a work with id Q001 with when filename = #{filename}" do
          uploader = UnsecureTmpBasicPictureUploader.new(batch_photo_uploads(:batch_photo_upload1))
          expect(uploader).to receive(:filename).and_return(filename).exactly(3).times
          expect(uploader.work).to eq works(:work1)
        end
      end

      ["7201284.jpg"].each do |filename|
        it "returns a work with alt number 7201284 with when filename = #{filename}" do
          batch_photo_upload = batch_photo_uploads(:batch_photo_upload1)
          batch_photo_upload.column = :alt_number_1
          uploader = UnsecureTmpBasicPictureUploader.new(batch_photo_upload)
          expect(uploader).to receive(:filename).and_return(filename).exactly(2).times
          expect(uploader.work).to eq works(:work1)
        end
      end
    end
  end

  describe "class methods" do
  end

end
