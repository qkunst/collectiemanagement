class AddTimeSpanIdToTimeSpans < ActiveRecord::Migration[6.1]
  def change
    add_column :time_spans, :time_span_id, :bigint
  end
end
