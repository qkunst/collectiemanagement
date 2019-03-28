# frozen_string_literal: true

class AddFacilityManagemerToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :facility_manager, :boolean
  end
end
