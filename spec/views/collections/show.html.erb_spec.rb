# frozen_string_literal: true

require_relative "../../rails_helper"

RSpec.describe "collections/show", type: :view do
  include Devise::Test::ControllerHelpers

  describe "Stages" do
    it "renders stages for admin" do
      sign_in users(:admin)

      @collection = collections(:collection_with_stages)
      @collections = @collection.collections
      @attachments = []
      render
      expect(rendered).to match(/Projectfase/)
      expect(rendered).to match(/Voltooid op  1 januari 2000/)
      expect(rendered).to match(/B2/)
    end
    it "renders stages for admin also for childs" do
      sign_in users(:admin)
      @collection = collections(:collection_with_stages_child)
      @collections = @collection.collections
      @attachments = []
      render
      expect(rendered).to match(/Projectfase/)
      expect(rendered).to match(/Voltooid op  1 januari 2000/)
      expect(rendered).to match(/B2/)
    end

    it "renders no stages when no stages are present for collection, even when admin" do
      sign_in users(:admin)
      @collection = collections(:collection1)
      @collections = @collection.collections
      @attachments = []
      render
      expect(rendered).not_to match(/Projectfase/)
      expect(rendered).not_to match(/Voltooid op  1 januari 2000/)
      expect(rendered).not_to match(/B2/)
    end
    it "renders no stages when read only" do
      sign_in users(:read_only_with_access_to_collection_with_stages)

      @collection = collections(:collection_with_stages)
      @collections = @collection.collections
      render
      expect(rendered).to match(/<h2>Collection with stages/)
      expect(rendered).not_to match(/Projectfase/)
      expect(rendered).not_to match(/Voltooid op  1 januari 2000/)
      expect(rendered).not_to match(/B2/)
    end
    it "renders no stages when read only, not even when in a subcollection" do
      sign_in users(:read_only_with_access_to_collection_with_stages)

      @collection = collections(:collection_with_stages_child)
      @collections = @collection.collections
      render
      expect(rendered).to match(/<h2>Collection with stages child/)
      expect(rendered).not_to match(/Projectfase/)
      expect(rendered).not_to match(/Voltooid op  1 januari 2000/)
      expect(rendered).not_to match(/B2/)
    end
  end
end
