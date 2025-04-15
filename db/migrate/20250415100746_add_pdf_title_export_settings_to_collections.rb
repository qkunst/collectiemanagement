class AddPdfTitleExportSettingsToCollections < ActiveRecord::Migration[7.2]
  def change
    add_column :collections, :pdf_title_export_variants_text, :text
  end
end
