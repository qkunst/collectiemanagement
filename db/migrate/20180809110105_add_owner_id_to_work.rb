class AddOwnerIdToWork < ActiveRecord::Migration[5.1]
  def change
    add_column :works, :owner_id, :integer
  end
end
