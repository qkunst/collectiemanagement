class CreateCustomReportTemplates < ActiveRecord::Migration[5.1]
  def change
    create_table :custom_report_templates do |t|
      t.string :title
      t.text :text
      t.integer :collection_id
      t.text :work_fields
      t.boolean :hide
      t.timestamps
    end
  end
end
