# frozen_string_literal: true

class ScheduleReindexWorkWorker
  include Sidekiq::Worker

  sidekiq_options retry: false, backtrace: true, queue: :qkunst_default

  def perform
    Work.select(:id).all.each do | work |
      ReindexWorkWorker.perform_async(work.id)
    end
  end
end
