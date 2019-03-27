# frozen_string_literal: true

class Validators::CollectionScopeValidator < ActiveModel::Validator
  def validate(record)
    if record.collection
      record.themes.each do |theme|
        unless theme.in? record.collection.available_themes
          record.errors.add(:base, "Theme “#{theme.name}” (id: #{theme.id}) is niet beschikbaar in collectie “#{record.collection.name}” (id: #{record.collection_id})")
        end
      end
      cluster = record.cluster
      if cluster
        unless cluster.in? record.collection.available_clusters
          record.errors.add(:base, "Cluster “#{cluster.name}” (id: #{cluster.id}) is niet beschikbaar in collectie “#{record.collection.name}” (id: #{record.collection_id})")
        end
      end
    end
  end
end
