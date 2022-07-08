# frozen_string_literal: true

module NameId
  extend ActiveSupport::Concern

  included do
    default_scope -> { order(:name) }
    scope :distinct_with_name, -> { distinct.unscope(:order) }
    scope :find_by_case_insensitive_name, ->(name) { where(arel_table[:name].matches_any([name].flatten)) }
    validates_presence_of :name

    def <=> other
      name <=> other.name
    end

    def to_json
      as_json(
        only: [:id, :name]
      )
    end

    def to_s
      "#<#{self.class.name}:#{name} (#{object_id})>"
    end

    def to_xml
      Nokogiri::XML::Builder.new { |xml|
        xml.root("xmlns" => "default", "xmlns:foo" => "bar") do
          xml.tenderlove
        end
      }
    end
  end

  class_methods do
    def names_hash
      unless defined?(@@names_hash) && @@names_hash[to_s]
        @@names_hash = {} unless defined?(@@names_hash)
        @@names_hash[to_s] = {}
        self.select("id,name").each do |objekt|
          @@names_hash[to_s][objekt.id] = objekt.name
        end
      end
      @@names_hash[to_s]
    end

    def names ids
      if ids.is_a? String
        ids = [ids.to_i]
      elsif ids.is_a? Integer
        ids = [ids]
      end
      rv = {}
      ids.each do |id|
        rv[id] = names_hash[id] || "Naamloos"
      end
      rv
    end

    def keyword_finder
      unless defined?(@@keyword_finder) && @@keyword_finder[to_s]
        @@keyword_finder = {} unless defined?(@@keyword_finder)
        @@keyword_finder[to_s] = KeywordFinder::Keywords.new(names_hash.collect { |a, v| v })
      end
      @@keyword_finder[to_s]
    end

    def find_in_string string
      keywords = keyword_finder.find_in(string)
      if keywords
        find_by_case_insensitive_name(keywords)
      end
    end

    def to_sentence
      all.collect(&:name).compact.uniq.to_sentence
    end
    alias_method :as_sentence, :to_sentence

    def to_sym
      to_s.downcase.to_sym
    end
  end
end
