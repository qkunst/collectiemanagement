# frozen_string_literal: true

class TestSearchWorker
  include Sidekiq::Worker

  sidekiq_options retry: false, backtrace: true, queue: :qkunst_often

  def perform
    Work.search("demo").first
  rescue Exception => e
    puts "Search werkt niet"
    ExceptionNotifier.notify_exception(e, data: {msg: "Search werkt niet!"})
  end
end
