class AddSetWorkAsRemovedFromCollectionToWorkStatuses < ActiveRecord::Migration[6.1]
  def change
    add_column :work_statuses, :set_work_as_removed_from_collection, :boolean
  end
end
