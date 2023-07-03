# frozen_string_literal: true

class UpdateWorkCachesWorker
  include Sidekiq::Worker

  sidekiq_options retry: false, backtrace: true, queue: :qkunst_default

  def perform(work_id, context = "artist")
    if context == "artist"
      w = Work.find(work_id)
      w.cache_collection_locality_artist_involvements_texts!(true)
      w.update_artist_name_rendered!
    end
  end
end
