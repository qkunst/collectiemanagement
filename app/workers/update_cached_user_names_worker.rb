# frozen_string_literal: true

class UpdateCachedUserNamesWorker
  include Sidekiq::Worker

  sidekiq_options retry: true, backtrace: true, queue: :qkunst_default

  def perform(user_id)
    user = User.find(user_id)
    user&.works_created&.update_all(created_by_name: user.name)
  end
end
