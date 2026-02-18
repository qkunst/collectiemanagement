# frozen_string_literal: true

# Column Cache helps caching column
# it introduces the methods #cache_#{method_name}! to refresh the cache and #cached_method_name to retrieve the cached version (explicitly)

module MethodCache
  extend ActiveSupport::Concern

  included do
  end
  class_methods do
    def has_cache_for_method(*method_names, as: nil, trigger: nil)
      method_names.each do |method_name|
        # cache_#{method_name}! caches a column, by default it uses write_attribute (which is better
        # at a before safe operation), but optionally you can choose update_colum for larger batches,
        # such as in a migration
        #
        # class AddCachedGeonameIdsToArtists < ActiveRecord::Migration[5.2]
        #   def change
        #     add_column :artists, :geoname_ids_cache, :text
        #     Artist.all.each{|artist| artist.cache_geoname_ids!(true)}
        #   end
        # end

        define_method(:"cache_#{method_name}") do
          new_cache_value = send(method_name).to_json
          self["#{method_name}_cache"] = new_cache_value
        end

        define_method(:"cache_#{method_name}!") do |update_column = true|
          new_cache_value = send(method_name).to_json
          if update_column
            update_column("#{method_name}_cache", new_cache_value)
          else
            self["#{method_name}_cache"] = new_cache_value
          end
        end

        define_method(:"cached_#{method_name}") do # |arg=nil| # default arg to allow before_blah callbacks
          column_value = self["#{method_name}_cache"]
          if column_value
            value = JSON.parse(column_value)
            value = value.map(&:to_sym) if as == :symbols && value.is_a?(Array)
            value
          end
        end

        if trigger
          if trigger == :after_safe
            send(trigger, :"cache_#{method_name}!")
          else
            send(trigger, :"cache_#{method_name}")
          end
        end
      end
    end
    alias_method :has_cache_for_methods, :has_cache_for_method
  end
end
