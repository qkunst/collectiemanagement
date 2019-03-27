# frozen_string_literal: true

require 'rails_helper'

RSpec.feature "UserCanEditPhotos", type: :feature do
  include ActiveSupport::Testing::TimeHelpers

  describe "collection changes" do
    it "should touch all related works" do
      travel -1.day do
        Work.update_all(updated_at: Time.now)
      end
      c = collections(:collection_with_works)
      c.name = "updated name"
      c.save
      expect(c.works_including_child_works.collect(&:updated_at).min).to be > 1.minute.ago
      expect(works(:collection_less_work).updated_at).to be < 23.hours.ago
    end
  end


  describe "artist changes" do
    it "should touch all related works" do
      a = artists(:artist2)
      w = a.works.first; w.save; w.reload # save & reload needed because incomplete record
      expect(w.artist_name_rendered).to eq("artist_2 achternaam, firstie")
      travel -1.day do
        Work.update_all(updated_at: Time.now)
      end
      a.year_of_birth = 1980
      a.save
      expect(a.works.collect(&:updated_at).min).to be > 1.minute.ago
      w.reload
      expect(w.artist_name_rendered).to eq("artist_2 achternaam, firstie (1980)")
      expect(works(:work1).updated_at).to be < 23.hours.ago
    end
  end
end
