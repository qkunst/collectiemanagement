# frozen_string_literal: true

class Validators::CollectionScopeValidator < ActiveModel::Validator
  def validate(record)
    if (collection = record.collection)
      collection_name = collection.name
      record.themes.each do |theme|
        unless theme.in? record.collection.available_themes(not_hidden: false)
          record.errors.add(:base, "Theme “#{theme.name}” (id: #{theme.id}) is niet beschikbaar in collectie “#{collection_name}” (id: #{record.collection_id})")
        end
      end
      cluster = record.cluster
      if cluster
        unless cluster.in? record.collection.available_clusters
          record.errors.add(:base, "Cluster “#{cluster.name}” (id: #{cluster.id}) is niet beschikbaar in collectie “#{collection_name}” (id: #{record.collection_id})")
        end
      end
    end
  end
end
