# frozen_string_literal: true

require "rails_helper"

RSpec.describe Collection::DownloadWorker, type: :model do
  it "works for xlsx" do
    collection = collections(:collection1)
    user = users(:admin)

    expect { Collection::DownloadWorker.new.perform(collection.id, user.id) }.to change(Message, :count).by(1)

    message = Message.last

    expect(message.subject).to eq("Download Collection 1 gereed")
    expect(message.attachment.file.path).to end_with(".xlsx")
  end
  it "works for csv" do
    collection = collections(:collection_with_works)
    user = users(:admin)

    expect { Collection::DownloadWorker.new.perform(collection.id, user.id, :csv) }.to change(Message, :count).by(1)

    message = Message.last

    expect(message.subject).to eq("Download Collection with works (sub of Collection 1) gereed")
    expect(message.attachment.file.path).to end_with(".csv")
  end
end
