# frozen_string_literal: true

class AddFacilityManagemerToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facility_manager, :boolean
  end
end
