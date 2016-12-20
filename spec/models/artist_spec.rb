require 'rails_helper'

RSpec.describe Artist, type: :model do
  describe  "#combine_artists_with_ids(artist_ids_to_combine_with)" do
    it "should work" do
      ids = []
      a = Artist.create(first_name: "a")
      wa = Work.create(title: "by a")
      wa.artists << a
      b = Artist.create(first_name: "b")
      ids << b.id

      wb = Work.create(title: "by a")
      wb.artists << b
      wb = Work.create(title: "by a")
      wb.artists << b

      expect(a.combine_artists_with_ids(ids)).to eq(2)
      expect(Artist.where(id: ids).count).to eq(0)
      expect(a.works.count).to eq(3)
    end
  end

  describe "Class methods" do
    describe ".empty_artists" do
      it "should list all workless-artists" do
        expect(Artist.empty_artists.count).to eq 1
        expect(Artist.empty_artists.first.id).to eq artists(:artist_no_works).id
      end
    end
    describe ".destroy_all_empty_artists!" do
      it "should destroy all workless-artists" do
        to_destroy_artist_id = artists(:artist_no_works).id
        destroyed_artists = Artist.destroy_all_empty_artists!
        expect(destroyed_artists.count).to eq 1
        expect(destroyed_artists.first.id).to eq to_destroy_artist_id
        expect(Artist.empty_artists.count).to eq 0
      end
      it "should list all workless-artists (check check)" do
        expect(Artist.empty_artists.count).to eq 1
        expect(Artist.empty_artists.first.id).to eq artists(:artist_no_works).id
      end
    end
    describe ".artists_with_no_name_that_have_works_that_already_belong_to_artists_with_a_name" do
      it "should list all workless-artists" do
        expect(Artist.artists_with_no_name_that_have_works_that_already_belong_to_artists_with_a_name.count).to eq 1
        expect(Artist.artists_with_no_name_that_have_works_that_already_belong_to_artists_with_a_name.first.id).to eq artists(:artist_no_name).id
      end
    end
    describe ".collapse_by_name!" do
      it "should colleapse only same creation date by default" do
        before_count = Artist.count
        Artist.collapse_by_name!
        expect(before_count - Artist.count).to eq 1
      end
      it "should colleapse only same creation date by default" do
        before_count = Artist.count
        Artist.collapse_by_name!({only_when_created_at_date_is_equal: false})
        expect(before_count - Artist.count).to eq 2
      end
    end
  end
end
