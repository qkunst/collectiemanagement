# frozen_string_literal: true

class AddNotAnExpertInventoryToWorks < ActiveRecord::Migration
  def change
    add_column :works, :external_inventory, :boolean
  end
end
