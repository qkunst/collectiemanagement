class CollectionsGeonameSummary < ApplicationRecord
  belongs_to :collection
  belongs_to :geoname_summary, primary_key: :geoname_id, foreign_key: :geoname_id
end
