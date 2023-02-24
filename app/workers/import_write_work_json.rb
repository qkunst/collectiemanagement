# frozen_string_literal: true

class ImportWriteWorkJson
  include Sidekiq::Worker

  class ImportError < StandardError; end

  sidekiq_options retry: false, backtrace: true, queue: :qkunst_quick

  def perform(import_id, work_data)
    import_collection = ImportCollection.find(import_id)
    import_collection.write_json_work(work_data)
  rescue Exception => e # standard:disable Lint/RescueException => this is really repackaging the same exception
    ie = ImportError.new("Work data failed (#{e.class}, #{e.message}): \n\n#{work_data}")
    ie.set_backtrace(e.backtrace)
    raise ie
  end
end
