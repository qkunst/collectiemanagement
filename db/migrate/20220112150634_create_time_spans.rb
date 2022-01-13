class CreateTimeSpans < ActiveRecord::Migration[6.1]
  def change
    create_table :time_spans do |t|
      t.datetime :starts_at
      t.datetime :ends_at
      t.integer :contact_id
      t.integer :subject_id
      t.string :subject_type
      t.string :status
      t.string :classification
      t.integer :collection_id
      t.timestamps
    end
  end
end
