# frozen_string_literal: true

require "rails_helper"

RSpec.describe CollectionDownloadWorker, type: :model do
  it "performs" do
    collection = collections(:collection_with_works)
    user = users(:admin)

    expect{ CollectionDownloadWorker.new.perform(collection.id, user.id) }.to change(Message, :count).by(1)

    message = Message.last

    expect(message.subject).to eq("Download Collection with works (sub of Collection 1) gereed")
    expect(message.attachment.file.path).to end_with(".xlsx")
  end
end