class AddSignificantlyUpdatedAtToWorks < ActiveRecord::Migration[6.1]
  def change
    add_column :works, :significantly_updated_at, :datetime

    execute "UPDATE works SET significantly_updated_at = updated_at;"
  end
end
