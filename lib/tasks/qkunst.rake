namespace :qkunst do
  desc "Herindexeer alle werken"
  task reindex: :environment do
    Work.reindex!
  end

  desc "Import Geonames data"
  task geonames_import: :environment do
    Geonames.import_all!
    puts "Done!"
  end

  desc "Doe de schoonmaak"
  task rinse_and_clean: :environment do
    Cluster.remove_all_without_works
    Artist.destroy_all_empty_artists!
    Artist.destroy_all_artists_with_no_name_that_have_works_that_already_belong_to_artists_with_a_name!
    Artist.collapse_by_name!({only_when_created_at_date_is_equal: true})
  end

  desc "Bouw nieuwe index op en herindexeer alle werken (traag)"
  task new_index: :environment do
    Work.reindex!(true)
  end
end
