# frozen_string_literal: true

class ScheduleReindexWorkWorker
  include Sidekiq::Worker

  sidekiq_options retry: true, backtrace: true, queue: :qkunst_default

  def perform
    Work.pluck(:id).each do |work_id|
      ReindexWorkWorker.set(queue: :qkunst_background).perform_async(work_id)
    end
  end
end
