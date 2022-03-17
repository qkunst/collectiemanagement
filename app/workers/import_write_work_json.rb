# frozen_string_literal: true

class ImportWriteWorkJson
  include Sidekiq::Worker

  sidekiq_options retry: true, backtrace: true, queue: :qkunst_often

  def perform(import_id, work_data)
    import_collection = ImportCollection.find(import_id)
    import_collection.write_json_work(work_data)
  end
end
