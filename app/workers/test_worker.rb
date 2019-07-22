# frozen_string_literal: true

class TestWorker
  include Sidekiq::Worker

  sidekiq_options retry: false, backtrace: true, queue: :qkunst_default

  def perform()
    sleep(1)
  end
end
