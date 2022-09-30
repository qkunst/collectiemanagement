class AddFacilityManagerSupportToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :facility_manager_support, :boolean
  end
end
