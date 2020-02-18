# frozen_string_literal: true

# works with the ColumnCache property
#
# UpdateCacheWorker.perform_async(self.name, field_name, self.id)
#
# or simpler to update all:
#
# UpdateCacheWorker.perform_async(self.name, field_name)


class UpdateCacheWorker
  include Sidekiq::Worker

  sidekiq_options retry: true, backtrace: true, queue: :qkunst_often

  def perform(class_name, field_name, id=nil)
    konstant = class_name.constantize
    if id == nil
      konstant.pluck(:id).each{|obj_id| UpdateCacheWorker.perform_async(class_name, field_name, obj_id)}
    else
      objekt = class_name.constantize.find(id)
      objekt.send("cache_#{field_name}!", true) #updates the cache using update_column
    end
  end
end
