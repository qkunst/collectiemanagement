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

  # pending "add some examples to (or delete) #{__FILE__}"
end
