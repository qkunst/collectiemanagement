# frozen_string_literal: true

# == Schema Information
#
# Table name: collections_geoname_summaries
#
#  id            :bigint           not null, primary key
#  collection_id :bigint
#  geoname_id    :bigint
#
class CollectionsGeonameSummary < ApplicationRecord
  belongs_to :collection
  belongs_to :geoname_summary, primary_key: :geoname_id, foreign_key: :geoname_id
end
