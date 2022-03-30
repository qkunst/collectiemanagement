class RemoveUrlFromTimeSpans < ActiveRecord::Migration[6.1]
  def change
    remove_column :time_spans, :url, :string
  end
end
