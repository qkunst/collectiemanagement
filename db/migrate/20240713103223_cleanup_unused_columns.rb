class CleanupUnusedColumns < ActiveRecord::Migration[7.1]
  def change
    remove_column :works, :entry_status, :string
    remove_column :works, :entry_status_description, :text
    remove_column :works, :removed_from_collection_note, :text
  end
end
