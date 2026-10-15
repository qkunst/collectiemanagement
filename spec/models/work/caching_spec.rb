require "rails_helper"

RSpec.describe Work::Caching do
  describe "update_artist_name_rendered" do
    it "stores the artist name after save" do
      w = Work.create(collection: collections(:collection1), title: "New work", artists: [artists(:artist1)])
      w.reload
      expect(w.artist_name_rendered).to eq("artist_1, firstname (1900 - 2000)")
    end
  end
end
