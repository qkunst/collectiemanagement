class StatusController < ApplicationController
  def application_status
    @sidekiq_running = Sidekiq::Workers.new.size > 0
    begin
      Collection.first.search_works("testsearch")[0]
      @elastic_search_running = true
    rescue
      @elastic_search_running = false
    end
  end
end
