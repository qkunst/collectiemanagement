# frozen_string_literal: true

class StatusController < ApplicationController
  def application_status
    @sidekiq_running = Sidekiq::Workers.new.size > 0
    if @sidekiq_running == false
      100.times { |t| TestWorker.perform_async(t / 100.0) }
      sleep(5)
      @sidekiq_running = Sidekiq::Workers.new.size > 0
    end
    begin
      Collection.first.search_works("testsearch")[0]
      @elastic_search_running = true
    rescue
      @elastic_search_running = false
    end
  end
end
