# frozen_string_literal: true

class StatusController < ApplicationController
  skip_before_action :authenticate_activated_user!
  layout false

  def application_status
    @sidekiq_running = Sidekiq::Workers.new.size > 0
    if @sidekiq_running == false
      before = sum_of_processed_and_in_process
      TestWorker.perform_async(0.1)
      30.times do |t|
        next if (@sidekiq_running = (before < sum_of_processed_and_in_process))

        sleep(1)
      end
    end
    begin
      Collection.first.search_works("testsearch")[0]
      @elastic_search_running = true
    rescue
      @elastic_search_running = false
    end
  end

  private

  def sum_of_processed_and_in_process
    (Sidekiq::Stats.new.processed + Sidekiq::Workers.new.size)
  end
end
