class AddPermanentlyFixedToWorks < ActiveRecord::Migration[6.0]
  def change
    add_column :works, :permanently_fixed, :boolean
  end
end
