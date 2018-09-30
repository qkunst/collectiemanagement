class UpdateCachedUserNamesJob < ApplicationJob
  queue_as :default

  def perform(user)
    user.works_created.update_all(created_by_name: user.name)
  end
end
