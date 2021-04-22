# frozen_string_literal: true

require "rails_helper"

RSpec.describe Collection::DownloadWorker, type: :model do
  it "performs a basic renderer" do
    collection = collections(:collection_with_works)
    user = users(:admin)

    html = Collection::HtmlRendererWorker.new.perform(collection.id, user.id)

    # expect html not to include any links
    expect(html).not_to match("<a ")

    expect(html).to match("Q001")
    expect(html).to match("Q002")
    expect(html).not_to match("Q006")
    expect(html).to match("Collectie Collection with works")

    # basic display by default
    expect(html).not_to match("Vervangingswaarde")
    expect(html).not_to match("Acrylverf")
    expect(html).not_to match("<h3>Houtskool</h3>")

  end

  it "performs a filtered render" do
    collection = collections(:collection_with_works)
    user = users(:admin)

    html = Collection::HtmlRendererWorker.new.perform(collection.id, user.id, {filter: {"object_categories.id"=>[object_categories(:gebouwgebonden).id]}, display: "complete"})

    # expect html not to include any links
    expect(html).not_to match("<a ")

    expect(html).to match("Q001")
    expect(html).not_to match("Q002")
    expect(html).not_to match("Q006")
    expect(html).to match("Collectie Collection with works")
    expect(html).to match("Vervangingswaarde")
    expect(html).to match("Acrylverf")
  end

  it "performs a grouped render" do
    collection = collections(:collection_with_works)
    user = users(:admin)

    html = Collection::HtmlRendererWorker.new.perform(collection.id, user.id, {group: "techniques"})

    # expect html not to include any links
    expect(html).not_to match("<a ")

    expect(html).to match("Q001")
    expect(html).to match("Q002")
    expect(html).not_to match("Q006")
    expect(html).to match("Collectie Collection with works")
    expect(html).to match("<h3>Houtskool</h3>")
  end

end
