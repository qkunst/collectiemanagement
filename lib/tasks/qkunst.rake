namespace :qkunst do
  desc "Herindexeer alle werken"
  task reindex: :environment do
    Work.reindex!
  end

  desc "Bouw nieuwe index op en herindexeer alle werken (traag)"
  task new_index: :environment do
    Work.reindex!(true)
  end
end
