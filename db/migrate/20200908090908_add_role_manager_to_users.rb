# frozen_string_literal: true

class AddRoleManagerToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :role_manager, :boolean
  end
end
