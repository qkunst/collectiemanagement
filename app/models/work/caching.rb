module Work::Caching
  extend ActiveSupport::Concern

  included do
    def cache_key(additional=[])
      [self, "v1.2"]+additional
    end

    def artist_name_rendered_without_years_nor_locality
      artist_name_rendered({include_years: false, include_locality: false})
    end

    def artist_name_rendered_without_years_nor_locality_semicolon_separated
      artist_name_rendered({include_years: false, include_locality: false, join: ";"})
    end

    def rebuild_artist_name_rendered(options={})
      rv = artists.order_by_name.distinct.collect{|a| a.name(options) if a.name(options).to_s.strip != ""}.compact.join(" ||| ")
      if artist_unknown and (rv.nil? or rv.empty?)
        rv = "Onbekend"
      end
      self.artist_name_rendered = rv
    end

    def artist_name_rendered(opts={})
      options = { join: :to_sentence }.merge(opts)
      rv = read_attribute(:artist_name_rendered).to_s
      rv = rebuild_artist_name_rendered(options) if options[:rebuild]
      rv = rv.to_s.gsub(/\s\(([\d\-\s]*)\)/,"") if options[:include_years] == false
      rv = options[:join] === :to_sentence ? rv.split(" ||| ").to_sentence : rv.split(" ||| ").join(options[:join])
      rv unless rv == ""
    end

    def update_artist_name_rendered!
      self.update_column(:artist_name_rendered, artist_name_rendered({rebuild:true, join: " ||| "}))
    end

    def update_latest_appraisal_data!
      latest_appraisal = appraisals.descending_appraisal_on.first
      if latest_appraisal
        self.market_value = latest_appraisal.market_value
        self.replacement_value = latest_appraisal.replacement_value
        self.price_reference = latest_appraisal.reference
        self.valuation_on = latest_appraisal.appraised_on
      else
        self.market_value = nil
        self.replacement_value = nil
        self.price_reference = nil
        self.valuation_on = nil
      end
      self.save
    end
  end
end