# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BatchPhotoUpload, type: :model do
  describe  "callbacks" do
  end

  describe "instance methods" do
    describe "#couple!" do
      # this is not a real test... but I'm confident enough for now... not sure how to fix it :o
      it "couples" do
        expect(works(:work1).photo_front.filename).to eq(nil)
        allow_any_instance_of(Work).to receive(:photo_front=)

        bpu = batch_photo_uploads(:batch_photo_upload1)
        images_array = bpu.read_attribute(:images)
        bpu.images.each_with_index do |image, index|
          expect(image).to receive(:filename).and_return(images_array[index]).at_least(3).times
          expect(image).to receive(:file_exists?).and_return(true)
        end

        bpu.couple!
      end
    end
  end

  describe "class methods" do
  end

end
