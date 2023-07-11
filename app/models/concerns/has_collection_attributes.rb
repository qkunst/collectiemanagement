module HasCollectionAttributes
  COLLECTION_ATTRIBUTES_PARAMS = [:label, :value, :attribute_type, :language].freeze

  extend ActiveSupport::Concern
  included do
    has_many :collection_attributes, as: :attributed

    def collection_attributes_attributes= collection_attribute_params
      # raise
      default_base_collection = methods.include?(:collection) ? collection.base_collection.id : nil
      collection_attribute_params.values.each do |collection_attribute_attributes|
        params = {collection_id: collection_attribute_attributes[:collection_id] || default_base_collection, attribute_type: collection_attribute_attributes[:attribute_type] || "unknown", language: collection_attribute_attributes[:language] || :not_applicable}
        if params[:attribute_type] == "unknown"
          params[:label] = collection_attribute_attributes[:label]
        end
        collection_attribute = collection_attributes.find_or_initialize_by(params)
        if collection_attribute_attributes[:value].present?
          collection_attribute.update(value: collection_attribute_attributes[:value])
        else # if collection_attribute.persisted?
          collection_attribute.destroy
        end
      end
    end

    # for new and create actions
    def populate_collection_attributes(collection:)
      collection = collection.base_collection
      default_collection_attributes = collection.send("default_collection_attributes_for_#{self.class.table_name}")&.select(&:present?)
      default_collection_languages = collection.supported_languages&.select(&:present?) || [:nl]

      default_collection_attributes&.each do |attribute_type|
        if CollectionAttribute::LOCALIZED_ATTRIBUTE_TYPES.include?(attribute_type)
          default_collection_languages&.each do |language|
            collection_attributes.find_or_initialize_by(attribute_type: attribute_type, collection: collection.base_collection, language: language)
          end
        else
          collection_attributes.find_or_initialize_by(attribute_type: attribute_type, collection: collection.base_collection, language: :not_applicable)
        end
      end
    end
  end
end
