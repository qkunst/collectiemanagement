# frozen_string_literal: true

class CreateCustomReports < ActiveRecord::Migration[5.1]
  def change
    create_table :custom_reports do |t|
      t.integer :custom_report_template_id
      t.string :title
      t.string :variables
      t.string :html_cache
      t.integer :collection_id

      t.timestamps
    end
    create_join_table :custom_reports, :works do |t|
      t.index [:custom_report_id, :work_id], unique: true
    end
  end
end
