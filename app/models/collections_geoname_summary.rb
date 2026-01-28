# frozen_string_literal: true
# == Schema Information
#
# Table name: collections_geoname_summaries
#
#  id            :integer          not null, primary key
#  collection_id :integer
#  geoname_id    :integer
#

class CollectionsGeonameSummary < ApplicationRecord
  belongs_to :collection
  belongs_to :geoname_summary, primary_key: :geoname_id, foreign_key: :geoname_id
end
