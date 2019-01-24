class AddAlsoUseInventoriedAtForWorkSortingToCollection < ActiveRecord::Migration[5.2]
  def change
    add_column :collections, :sort_works_by, :string
  end
end
