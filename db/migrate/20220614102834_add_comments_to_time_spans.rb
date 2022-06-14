class AddCommentsToTimeSpans < ActiveRecord::Migration[6.1]
  def change
    add_column :time_spans, :comments, :text
  end
end
