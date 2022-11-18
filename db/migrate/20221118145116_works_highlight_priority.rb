class WorksHighlightPriority < ActiveRecord::Migration[7.0]
  def change
    # rename_column :works, :highlight_at, :highlight_priority
    add_column :works, :highlight_priority, :integer

    Work.where.not(highlight_at: ["", nil]).update_all(highlight_priority: 1)
    remove_column :works, :highlight_at
  end
end