# frozen_string_literal: true

class SourceQkunstbeheer::SidekiqErrorLogger
  def call(worker, msg, queue)
    yield
  rescue => ex
    SystemMailer.sidekiq_error_message(ex, worker).deliver!
    raise ex
  end
end

Sidekiq.configure_server do |config|
  config.client_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Client unless Rails.env.test?
  end
  config.server_middleware do |chain|
    chain.add SourceQkunstbeheer::SidekiqErrorLogger
    chain.add SidekiqUniqueJobs::Middleware::Server unless Rails.env.test?
  end

  SidekiqUniqueJobs::Server.configure(config) unless Rails.env.test?
end

Sidekiq.configure_client do |config|
  config.client_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Client unless Rails.env.test?
  end
end
