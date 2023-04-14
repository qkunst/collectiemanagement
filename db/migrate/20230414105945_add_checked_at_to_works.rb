class AddCheckedAtToWorks < ActiveRecord::Migration[7.0]
  def change
    add_column :works, :checked_at, :datetime
  end
end
