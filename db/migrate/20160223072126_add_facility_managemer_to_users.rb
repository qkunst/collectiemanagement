class AddFacilityManagemerToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facility_manager, :boolean
  end
end
