# frozen_string_literal: true

class AddNotAnExpertInventoryToWorks < ActiveRecord::Migration[4.2]
  def change
    add_column :works, :external_inventory, :boolean
  end
end
