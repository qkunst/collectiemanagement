class AddUrlToTimeSpans < ActiveRecord::Migration[6.1]
  def change
    add_column :time_spans, :url, :string
  end
end
