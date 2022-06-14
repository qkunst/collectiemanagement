class AddOldDataToTimeSpans < ActiveRecord::Migration[6.1]
  def change
    add_column :time_spans, :old_data, :text
  end
end
