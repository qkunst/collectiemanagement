class AddCommentsToWorkSets < ActiveRecord::Migration[6.1]
  def change
    add_column :work_sets, :comment, :text
  end
end
