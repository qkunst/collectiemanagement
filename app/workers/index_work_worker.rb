# frozen_string_literal: true

class IndexWorkWorker
  include Sidekiq::Worker

  sidekiq_options retry: false, backtrace: true, queue: :qkunst_often

  def perform(work_id)
    work = Work.find_by_id(work_id)
    work.reindex! if work
  end
end
