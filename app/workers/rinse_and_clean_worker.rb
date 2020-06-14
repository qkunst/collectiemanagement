# frozen_string_literal: true

class RinseAndCleanWorker
  include Sidekiq::Worker

  sidekiq_options retry: false, backtrace: true, queue: :qkunst_default

  def perform
    Cluster.remove_all_without_works
    Artist.destroy_all_empty_artists!
    Work.update_artist_name_rendered!
    Artist.destroy_all_artists_with_no_name_that_have_works_that_already_belong_to_artists_with_a_name!
    Artist.collapse_by_name!({only_when_created_at_date_is_equal: true})
    CachedApi.purge
  end
end
