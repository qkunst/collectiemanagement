class AddShowLibraryToCollections < ActiveRecord::Migration[6.1]
  def change
    add_column :collections, :show_library, :boolean
  end
end
