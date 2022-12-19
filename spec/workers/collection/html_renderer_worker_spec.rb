# frozen_string_literal: true

require "rails_helper"

RSpec.describe Collection::HtmlRendererWorker, type: :model do
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

  it "performs a filtered render", requires_elasticsearch: true do
    collection = collections(:collection_with_works)
    user = users(:admin)

    # required for TravisCI
    collections(:collection_with_works).works_including_child_works.all.reindex!

    html = Collection::HtmlRendererWorker.new.perform(collection.id, user.id, {filter: {"object_categories.id" => [object_categories(:gebouwgebonden).id]}, display: "complete"})

    # expect html not to include any links
    expect(html).not_to match("<a ")

    expect(html).to match("Q001")
    expect(html).not_to match("Q002")
    expect(html).not_to match("Q006")
    expect(html).to match("Collectie Collection with works")
    expect(html).to match("Vervangingswaarde")
    expect(html).to match("Plaatsbaarheid")
    expect(html).to match("Acrylverf")
    expect(html).to match("Interne opmerking bij werk 1")
  end

  it "doesn't export internal comments to facility manager", requires_elasticsearch: true do
    collection = collections(:collection_with_works)
    user = users(:facility_manager)

    # required for TravisCI
    collections(:collection_with_works).works_including_child_works.all.reindex!

    html = Collection::HtmlRendererWorker.new.perform(collection.id, user.id, {filter: {"object_categories.id" => [object_categories(:gebouwgebonden).id]}, display: "complete"})

    # expect html not to include any links
    expect(html).not_to match("<a ")

    expect(html).to match("Q001")
    expect(html).not_to match("Q002")
    expect(html).not_to match("Q006")
    expect(html).to match("Collectie Collection with works")
    expect(html).to match("Vervangingswaarde")
    expect(html).to match("Plaatsbaarheid")
    expect(html).to match("Acrylverf")
    expect(html).not_to match("Interne opmerking bij werk 1")
  end

  it "doesn't show complete data to read only user", requires_elasticsearch: true do
    collection = collections(:collection_with_works)
    user = users(:read_only)

    # required for TravisCI
    collections(:collection_with_works).works_including_child_works.all.reindex!

    html = Collection::HtmlRendererWorker.new.perform(collection.id, user.id, {filter: {"object_categories.id" => [object_categories(:gebouwgebonden).id]}, display: "complete"})

    # expect html not to include any links
    expect(html).not_to match("<a ")

    expect(html).to match("Q001")
    expect(html).not_to match("Q002")
    expect(html).not_to match("Q006")
    expect(html).to match("Collectie Collection with works")
    expect(html).not_to match("Vervangingswaarde")
    expect(html).not_to match("Plaatsbaarheid")
    expect(html).not_to match("Acrylverf")
    expect(html).not_to match("Interne opmerking bij werk 1")
  end

  it "does show basic data to read only", requires_elasticsearch: true do
    collection = collections(:collection_with_works)
    user = users(:read_only)

    # required for TravisCI
    collections(:collection_with_works).works_including_child_works.all.reindex!

    html = Collection::HtmlRendererWorker.new.perform(collection.id, user.id, {filter: {"object_categories.id" => [object_categories(:gebouwgebonden).id]}, display: "detailed"})

    # expect html not to include any links
    expect(html).not_to match("<a ")

    expect(html).to match("Q001")
    expect(html).not_to match("Q002")
    expect(html).not_to match("Q006")
    expect(html).to match("Collectie Collection with works")
    expect(html).not_to match("Vervangingswaarde")
    expect(html).not_to match("Plaatsbaarheid")
    expect(html).to match("Acrylverf")
    expect(html).not_to match("Interne opmerking bij werk 1")
  end

  it "does not render any data when none", requires_elasticsearch: true do
    collection = collections(:collection_with_works)
    user = nil

    # required for TravisCI
    collections(:collection_with_works).works_including_child_works.all.reindex!

    expect do
      Collection::HtmlRendererWorker.new.perform(collection.id, user&.id, {filter: {"object_categories.id" => [object_categories(:gebouwgebonden).id]}, display: "detailed"})
    end.to raise_error(ActiveRecord::RecordNotFound)
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

  it "triggers generation of a pdf" do
    collection = collections(:collection_with_works)
    user = users(:admin)

    expect(SecureRandom).to receive(:base58).and_return("abc")
    expect(PdfPrinterWorker).to receive(:perform_async).with(Rails.root.join("tmp/abc.html"), inform_user_id: user.id, subject_object_id: collection.id, subject_object_type: "Collection")

    Collection::HtmlRendererWorker.new.perform(collection.id, user.id, {group: "techniques"}, {generate_pdf: true, send_message: true})
  end
end
