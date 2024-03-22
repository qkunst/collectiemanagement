class AddDeactivatedAtToWorkSets < ActiveRecord::Migration[7.1]
  def change
    add_column :work_sets, :deactivated_at, :datetime
  end
end
