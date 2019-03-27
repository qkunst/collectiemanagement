# frozen_string_literal: true

namespace :qkunst do
  desc "Herindexeer alle werken"
  task reindex: :environment do
    puts "Replaced by sidekiq scheduler"
  end

  desc "Import Geonames data"
  task geonames_import: :environment do
    Geoname.import_all!
    puts "Done!"
  end

  desc "Doe de schoonmaak"
  task rinse_and_clean: :environment do
    Cluster.remove_all_without_works
    Artist.destroy_all_empty_artists!
    Work.update_artist_name_rendered!
    Artist.destroy_all_artists_with_no_name_that_have_works_that_already_belong_to_artists_with_a_name!
    Artist.collapse_by_name!({only_when_created_at_date_is_equal: true})
    CachedApi.purge
  end

  desc "Bouw nieuwe index op en herindexeer alle werken (traag)"
  task new_index: :environment do
    begin
      Work.__elasticsearch__.delete_index!
    rescue Elasticsearch::Transport::Transport::Errors::NotFound
      puts "Already deleted..."
    end
    Work.reindex!(true)
  end

  desc "Send all reminders"
  task send_reminders: :environment do
    Reminder.send_reminders!
  end

  desc "test availability of the search engine"
  task test_search: :environment do
    begin
      Work.search("demo").first
    rescue Exception => e
      puts "Search werkt niet"
      ExceptionNotifier.notify_exception(e, :data => {:msg => "Search werkt niet!"})
    end
  end
end
