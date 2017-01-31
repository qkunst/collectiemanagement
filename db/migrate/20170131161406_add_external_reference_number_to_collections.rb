class AddExternalReferenceNumberToCollections < ActiveRecord::Migration[5.0]
  def change
    add_column :collections, :external_reference_code, :string
  end
end
