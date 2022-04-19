# frozen_string_literal: true

require "rails_helper"

RSpec.describe ImportCollection, type: :model do
  describe "instance methods" do
    describe "#write_json_work" do
      it "creates a simple work" do
        title = "New work very unique json imported"
        import_collections(:import_collection1).write_json_work({"title"=>title})
        expect(collections(:collection1).works.where(title: title).count).to eq(1)
      end
      it "creates a new artist if id is given" do
        title = "New work very unique json imported with artist"
        import_collections(:import_collection1).write_json_work({"title"=>title, "artists"=>[{"rkd_artist_id"=>123, "last_name"=>"Camembert"}]})

        work = collections(:collection1).works.find_by(title: title)
        expect(work.title).to eq(title)
        expect(work.artists.map(&:last_name)).to include "Camembert"
      end
    end
  end
end
