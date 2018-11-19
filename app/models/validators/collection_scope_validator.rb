class Validators::CollectionScopeValidator < ActiveModel::Validator
  def validate(record)
    if record.collection
      record.themes.each do |theme|
        unless theme.in? record.collection.available_themes
          record.errors.add(:base, "#{theme.name} (id: #{theme.id}) is not available in collection #{record.collection.name} (id: #{record.collection_id})")
        end
      end
      cluster = record.cluster
      if cluster
        unless cluster.in? record.collection.available_clusters
          record.errors.add(:base, "#{cluster.name} (id: #{cluster.id}) is not available in collection #{record.collection.name} (id: #{record.collection_id})")
        end
      end
    end
  end
end