module NameId
  extend ActiveSupport::Concern

  included do

    default_scope ->{ order(:name) }

    def <=> other
      self.name <=> other.name
    end

    def to_json
      self.as_json(
        only: [:id, :name]
      )
    end
  end

  class_methods do
    def names_hash
      unless defined?(@@names_hash)
        @@names_hash = {}
        self.select("id,name").each do |objekt|
          @@names_hash[objekt.id] = objekt.name
        end
      end
      @@names_hash
    end

    def names ids
      if ids.is_a? String
        ids = [ids.to_i]
      elsif ids.is_a? Integer
        ids = [ids]
      end
      rv = {}
      ids.each do |id|
        rv[id] = names_hash[id]
      end
      return rv
    end

    def to_sym
      self.to_s.downcase.to_sym
    end

    def find_by_case_insensitive_name name
      self.where(arel_table[:name].matches(name))
    end
  end
end