# frozen_string_literal: true

class StatsController < ApplicationController
  include Works::Filtering

  before_action :set_collection # set_collection includes authentication

  def show
    authorize! :read_report, @collection

    @inventoried_objects_count = @collection.works_including_child_works.count
    @collection_works_count = @works_count = @collection.works_including_child_works.count_as_whole_works
    @artists_count = @collection.artists.count

    @artists_gender_stats = artist_gender_stats
    @technique_stats = technique_stats
    @object_creation_year_stats = object_creation_year_stats
  end

  private

  def technique_stats
    tally_hash_to_chartjs_data(works.left_outer_joins(:techniques).select("techniques.name").pluck(:name).map { |a| a.blank? ? "Onbekend" : a }.tally)
  end

  def artist_gender_stats
    tally_hash_to_chartjs_data(works.left_outer_joins(:artists).select("artists.gendfer").pluck(:gender).map { |a| a.blank? ? "unknown" : a }.tally.map { |k, v| [I18n.t(k, scope: "activerecord.values.artist.gender"), v] }.to_h)
  end

  def object_creation_year_stats
    object_creation_year_tally = works.select("object_creation_year").pluck(:object_creation_year).compact.tally

    tally_years_hash_to_chartjs_data(object_creation_year_tally)
  end

  def tally_years_hash_to_chartjs_data(tally)
    min_year = tally.keys.min.to_i
    max_year = tally.keys.max.to_i
    zero_hash = (min_year - 1..max_year + 1).map { |year| [year, 0] }.to_h
    tally = zero_hash.merge(tally)
    labels = tally.keys
    data = tally.values
    {labels: labels, datasets: [data: data]}
  end

  def tally_hash_to_chartjs_data(tally)
    tally = tally.sort_by { |a| -a[1] }.to_h
    if tally.size > 25
      first_25 = tally.to_a[0..24]
      others_sum = tally.to_a[25..].map { |a| a[1] || 0 }.sum

      tally = first_25.to_h
      tally["Overig"] = others_sum
    end
    labels = tally.keys
    data = tally.values
    {labels: labels, datasets: [data: data]}
  end

  def works
    @collection.works_including_child_works
  end
end
