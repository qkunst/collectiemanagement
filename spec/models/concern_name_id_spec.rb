require 'rails_helper'

RSpec.describe NameId, type: :model do
  describe  "#names_hash" do
    it "should work" do
      expect(Subset.names_hash.values).to include("Historical")
      expect(Subset.names_hash.values).to include("Modern")
      expect(Subset.names_hash.values).to include("Contemporary")
      expect(Theme.names_hash.values).to include("earth")
      expect(Theme.names_hash.values).to include("wind")
      expect(Theme.names_hash.values).to include("fire")
    end
  end

  # describe "Class methods" do
 #    describe ".empty_artists" do
 #      it "should list all workless-artists" do
 #        expect(Artist.empty_artists.count).to eq 1
 #        expect(Artist.empty_artists.first.id).to eq artists(:artist_no_works).id
 #      end
 #    end
 #    describe ".destroy_all_empty_artists!" do
 #      it "should destroy all workless-artists" do
 #        to_destroy_artist_id = artists(:artist_no_works).id
 #        destroyed_artists = Artist.destroy_all_empty_artists!
 #        expect(destroyed_artists.count).to eq 1
 #        expect(destroyed_artists.first.id).to eq to_destroy_artist_id
 #        expect(Artist.empty_artists.count).to eq 0
 #      end
 #      it "should list all workless-artists (check check)" do
 #        expect(Artist.empty_artists.count).to eq 1
 #        expect(Artist.empty_artists.first.id).to eq artists(:artist_no_works).id
 #      end
 #    end
 #    describe ".artists_with_no_name_that_have_works_that_already_belong_to_artists_with_a_name" do
 #      it "should list all workless-artists" do
 #        expect(Artist.artists_with_no_name_that_have_works_that_already_belong_to_artists_with_a_name.count).to eq 1
 #        expect(Artist.artists_with_no_name_that_have_works_that_already_belong_to_artists_with_a_name.first.id).to eq artists(:artist_no_name).id
 #      end
 #    end
 #    describe ".collapse_by_name!" do
 #      it "should colleapse only same creation date by default" do
 #        before_count = Artist.count
 #        Artist.collapse_by_name!
 #        expect(before_count - Artist.count).to eq 1
 #      end
 #      it "should colleapse only same creation date by default" do
 #        before_count = Artist.count
 #        Artist.collapse_by_name!({only_when_created_at_date_is_equal: false})
 #        expect(before_count - Artist.count).to eq 2
 #      end
 #    end
 #  end
end
