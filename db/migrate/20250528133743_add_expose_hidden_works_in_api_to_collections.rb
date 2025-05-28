class AddExposeHiddenWorksInApiToCollections < ActiveRecord::Migration[7.2]
  def change
    add_column :collections, :api_setting_expose_only_published_works, :boolean
  end
end
