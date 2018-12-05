# Column Cache helps caching column
# it introduces the methods #cache_#{column_name}! to refresh the cache and #cached_column_name to retrieve the cached version (explicitly)

module ColumnCache
  extend ActiveSupport::Concern

  included do

  end
  class_methods do
    def has_cache_for_column(*column_names)
      column_names.each do |column_name|
        # cache_#{column_name}! caches a column, by default it uses write_attribute (which is better
        # at a before safe operation), but optionally you can choose update_colum for larger batches,
        # such as in a migration
        #
        # class AddCachedGeonameIdsToArtists < ActiveRecord::Migration[5.2]
        #   def change
        #     add_column :artists, :geoname_ids_cache, :text
        #     Artist.all.each{|artist| artist.cache_geoname_ids!(true)}
        #   end
        # end

        define_method("cache_#{column_name}!") do |update_column=false|
          new_cache_value = send(column_name).to_json
          if update_column
            update_column("#{column_name}_cache", new_cache_value)
          else
            write_attribute("#{column_name}_cache", new_cache_value)
          end
        end

        define_method("cached_#{column_name}") do #|arg=nil| # default arg to allow before_blah callbacks
          column_value = read_attribute("#{column_name}_cache")
          JSON.parse(column_value) if column_value
        end
      end
    end
    # alias_method :has_cache_for_column, :has_cache_for_columns
  end
end