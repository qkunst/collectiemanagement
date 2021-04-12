# frozen_string_literal: true

class ReindexWorkWorker
  include Sidekiq::Worker

  sidekiq_options retry: true, backtrace: true, queue: :qkunst_default

  def perform(work_id)
    work = Work.find_by_id(work_id)
    work&.reindex!
  end
end
