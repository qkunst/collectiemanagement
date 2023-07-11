class DataMigratePublicDescriptionToCollectionAttributes < ActiveRecord::Migration[7.0]
  def change
    collections = []
    Work.where.not(public_description: nil).each do |work|
      base_collection = work.collection.base_collection
      collections << base_collection
      work.collection_attributes.create!(value: work.public_description, collection: base_collection, language: "nl", attribute_type: "public_description")
    end

    collections.each do |collection|
      collection.update_column(:default_collection_attributes_for_works, ["public_description"])
    end
  end
end
