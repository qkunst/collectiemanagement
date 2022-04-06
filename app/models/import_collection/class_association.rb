# frozen_string_literal: true

class ImportCollection::ClassAssociation
  attr_accessor :relation, :name, :class_name, :collection

  def initialize(options = {})
    options.each do |k, v|
      send("#{k}=", v)
    end
  end

  def scoped_klass
    @scoped_klass ||= collection.methods.include?(:"available_#{name}") ? collection.send(:"available_#{name}") : class_name.constantize
  end

  def klass
    scoped_klass || class_name.constantize
  end

  def implements_find_by_name?
    klass.methods.include? :find_by_name
  end

  def has_name_column?
    klass.column_names.include? "name"
  end

  def findable_by_name?
    has_name_column? || implements_find_by_name?
  end

  def has_many_and_maybe_belongs_to_many?
    [:has_many, :has_and_belongs_to_many].include?(relation)
  end

  def importable?
    unless ["PaperTrail::Version", "Currency", "Attachment", "ActsAsTaggableOn::Tag", "ActsAsTaggableOn::Tagging", "::ActsAsTaggableOn::Tag", "::ActsAsTaggableOn::Tagging", "CustomReport", "LibraryItem", "WorkSet", "Message", "TimeSpan", "ImportCollection"].include? class_name
      return true
    end
    false
  end

  def find_by_name name
    if implements_find_by_name?
      klass.find_by_name(name)
    elsif has_name_column?
      klass.where(klass.arel_table[:name].matches(name)).first
    end
  end
end
