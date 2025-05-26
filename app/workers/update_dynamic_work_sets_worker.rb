# frozen_string_literal: true

class UpdateDynamicWorkSetsWorker
  include Sidekiq::Worker

  sidekiq_options retry: true, backtrace: true, queue: :qkunst_background

  def perform
    work_sets = WorkSet.dynamic.not_deactivated
    work_sets.map { |ws| ws.update_with_works_filter_params }
  end
end
