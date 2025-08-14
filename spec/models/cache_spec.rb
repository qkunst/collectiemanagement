# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Cache spec", type: :model do
  include ActiveSupport::Testing::TimeHelpers

  describe "collection that changes" do
    it "should touch all related works" do
      travel(-1.day) do
        Work.update_all(updated_at: Time.now)
      end
      c = collections(:collection_with_works)
      c.name = "updated name"
      c.save
      expect(c.works_including_child_works.collect(&:updated_at).min).to be > 1.minute.ago
      expect(works(:collection_less_work).updated_at).to be < 23.hours.ago
    end
  end

  describe "artist that changes" do
    it "should touch all related works" do
      Sidekiq::Testing.inline! do
        a = artists(:artist2)
        w = works(:work2)
        w.save
        w.reload # save & reload needed because incomplete record
        expect(w.artist_name_rendered).to eq("artist_2 achternaam, firstie (1969)")
        travel(-1.day) do
          Work.update_all(updated_at: Time.now)
        end
        a.year_of_birth = nil
        a.save
        a.reload
        expect(a.works.collect(&:updated_at).min).to be > 1.minute.ago
        w.reload
        expect(w.artist_name_rendered).to eq("artist_2 achternaam, firstie")
        expect(works(:work1).updated_at).to be < 23.hours.ago
      end
    end
  end
end
