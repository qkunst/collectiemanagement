# frozen_string_literal: true

namespace :qkunst do
  desc "Herindexeer alle werken"
  task reindex: :environment do
    puts "Replaced by sidekiq scheduler; ScheduleReindexWorkWorker.perform_async"
  end

  desc "Import Geonames data"
  task geonames_import: :environment do
    Geoname.import_all!
    puts "Done!"
  end

  desc "Doe de schoonmaak"
  task rinse_and_clean: :environment do
    puts "Replaced by sidekiq scheduler; RinseAndCleanWorker.perform_async"
  end

  desc "Bouw nieuwe index op en herindexeer alle werken (traag)"
  task new_index: :environment do
    begin
      Work.__elasticsearch__.delete_index!
    rescue Elasticsearch::Transport::Transport::Errors::NotFound
      puts "Already deleted..."
    end
    Work.__elasticsearch__.create_index!
    ScheduleReindexWorkWorker.perform_async
  end

  desc "Bouw nieuwe index op en herindexeer alle werken in sync (traag)"
  task new_index_and_sync: :environment do
    begin
      Work.__elasticsearch__.delete_index!
    rescue Elasticsearch::Transport::Transport::Errors::NotFound
      puts "Already deleted..."
    end
    Work.__elasticsearch__.create_index!
    ScheduleReindexWorkWorker.new.perform
  end

  desc "Send all reminders"
  task send_reminders: :environment do
    Reminder.send_reminders!
  end
end
