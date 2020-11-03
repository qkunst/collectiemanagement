class SourceQkunstbeheer::SidekiqErrorLogger
  def call(worker, msg, queue)
    begin
      yield
    rescue => ex
      SystemMailer.error_message(ex)
    end
  end
end

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add SourceQkunstbeheer::SidekiqErrorLogger
  end
end