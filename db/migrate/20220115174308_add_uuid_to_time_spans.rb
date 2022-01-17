class AddUuidToTimeSpans < ActiveRecord::Migration[6.1]
  def change
    add_column :time_spans, :uuid, :string
  end
end
