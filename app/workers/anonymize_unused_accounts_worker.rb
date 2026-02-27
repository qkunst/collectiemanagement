class AnonymizeUnusedAccountsWorker
  include Sidekiq::Worker

  sidekiq_options retry: true, backtrace: true, queue: :qkunst_quick

  def perform
    User.where(last_sign_in_at: (15.months.ago...14.months.ago)).find_each do |user|
      if user.collections.empty?
        user.destroy!
      else
        user.anonymize!
      end
    end
  end
end
