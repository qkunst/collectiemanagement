class AddShowAvailabilityStatusToCollections < ActiveRecord::Migration[6.1]
  def change
    add_column :collections, :show_availability_status, :boolean
  end
end
