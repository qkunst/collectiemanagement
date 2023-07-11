class AddLanguageToCollectionAttributes < ActiveRecord::Migration[7.0]
  COLLECTION_ATTRIBUTE_LABELS = {
    "mailadres" => :email, "telefoonnummer" => :telephone_number, "website" => :website, "beschrijving" => :description, "description" => :description
  }

  def change
    add_column :collection_attributes, :language, :string
    add_column :collection_attributes, :attribute_type, :string, default: "unknown"

    CollectionAttribute.all.each do |collection_attribute|
      type = COLLECTION_ATTRIBUTE_LABELS[collection_attribute.label.downcase] || :unknown
      collection_attribute.update(
        language: (type == :description) ? :nl : :not_applicable,
        attribute_type: type,
        label: (type == :unknown) ? collection_attribute.label : nil
      )
    end
  end
end
