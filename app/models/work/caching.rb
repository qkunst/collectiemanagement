# frozen_string_literal: true

module Work::Caching
  extend ActiveSupport::Concern

  included do
    def cache_key(additional = [])
      [self, "v1.3"] + additional
    end

    def artist_name_rendered_without_years_nor_locality
      artist_name_rendered({include_years: false, include_locality: false})
    end

    def artist_name_rendered_without_years_nor_locality_semicolon_separated
      artist_name_rendered({include_years: false, include_locality: false, join: ";"})
    end

    def artist_name_rendered(opts = {})
      options = {include_years: true, include_locality: false, join: :to_sentence, render_error: false}.merge(opts)
      simple_artists = begin
        SimpleArtist.new_from_json(read_attribute(:artist_name_rendered))
      rescue JSON::ParserError
        if attributes["artist_name_rendered"]
          return attributes["artist_name_rendered"]
        else
          SimpleArtist.new_from_json(artists.to_json_for_simple_artist)
        end
      end

      names = [simple_artists].flatten.collect { |a| a.name(options) }.delete_if(&:blank?)

      return "Onbekend" if artist_unknown && names.empty?
      return nil if names.empty?
      options[:join] == :to_sentence ? names.to_sentence : names.join(options[:join])
    end

    def update_created_by_name
      self.created_by_name = created_by.name if created_by
    end

    def update_artist_name_rendered!
      self.artist_name_rendered = artists.to_json_for_simple_artist
      update_columns(artist_name_rendered: self.read_attribute(:artist_name_rendered), artist_name_for_sorting: artist_name_rendered_without_years_nor_locality_semicolon_separated, updated_at: Time.now)
    end

    def update_latest_appraisal_data!
      latest_appraisal = appraisals.descending_appraisal_on.first
      if latest_appraisal
        self.market_value = latest_appraisal.market_value
        self.replacement_value = latest_appraisal.replacement_value
        self.replacement_value_min = latest_appraisal.replacement_value_min
        self.replacement_value_max = latest_appraisal.replacement_value_max
        self.market_value_min = latest_appraisal.market_value_min
        self.market_value_max = latest_appraisal.market_value_max
        self.price_reference = latest_appraisal.reference
        self.valuation_on = latest_appraisal.appraised_on
        self.appraisal_notice = latest_appraisal.notice
      else
        self.market_value = nil
        self.replacement_value = nil
        self.replacement_value_min = nil
        self.replacement_value_max = nil
        self.market_value_min = nil
        self.market_value_max = nil
        self.price_reference = nil
        self.valuation_on = nil
        self.appraisal_notice = nil
      end
      save
    end
  end
  class_methods do
    def update_artist_name_rendered!
      all.each do |w|
        w.update_artist_name_rendered!
        w.save if w.changes != {}
      end
    end
  end
end
