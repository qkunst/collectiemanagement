# frozen_string_literal: true

class CreateTableSourcesWorks < ActiveRecord::Migration[4.2]
  def change
    create_table :sources_works do |t|
      t.integer :work_id
      t.integer :source_id
    end
    Work.where("works.source_id IS NOT NULL").each do | work |
      work.sources << work.source
      puts "Moved source #{work.source.name} of #{work.artist_name_rendered} - #{work.title_rendered}..."
    end
  end
end
