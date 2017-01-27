class AddAppraiserToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :appraiser, :boolean
  end
end
