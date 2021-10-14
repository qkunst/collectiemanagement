# frozen_string_literal: true

class ImportCollection < ApplicationRecord
  belongs_to :collection
  has_many :artists
  has_many :works

  store :settings, accessors: [:header_row, :import_settings, :decimal_separator, :external_inventory]

  mount_uploader :file, TableUploader

  def workbook(f = file)
    if f.path
      @workbook ||= Workbook::Book.open(f.path)
    end
  end

  def decimal_separator_with_fallback
    decimal_separator || ","
  end

  def import_setting_for field
    settings = import_settings && import_settings[field.to_s] ? import_settings[field.to_s] : {}
    {"fields" => [], "split_strategy" => "split_nothing", "assign_strategy" => "append"}.merge(settings)
  end

  def internal_header_row_offset
    offset = 0
    offset += (header_row.to_i - 1) if header_row && (header_row.to_i > 0)
    offset
  end

  def import_file_snippet_to_workbook_table
    return nil if import_file_snippet.nil? || import_file_snippet.empty?
    offset = internal_header_row_offset
    table = Workbook::Table.new
    Workbook::Book.read(import_file_snippet, :csv, {converters: []}).sheet.table.each_with_index do |row, index|
      if index >= offset
        table << row
      end
    end
    table
  end

  def import_file_to_workbook_table
    return nil if import_file_snippet.nil? || import_file_snippet.empty?

    offset = internal_header_row_offset
    table = Workbook::Table.new
    workbook.sheet.table.each_with_index do |row, index|
      if index >= offset
        table << row
      end
    end
    table
  end

  def read(table = import_file_snippet_to_workbook_table)
    table.collect do |row|
      unless row.header?
        process_table_data_row(row)
      end
    end.compact
  end

  def collapse_all_generated_artists
    artists.collapse_by_name!
  end

  def analyze_field_properties(field)
    objekt, fieldname = field.split(".")

    property = nil
    association = false
    has_many_association = false
    complex_association = false
    field_type = :string

    if objekt == "work"
      association = find_import_association_by_name(fieldname.to_sym)
      property = fieldname
      if association
        property = "#{property.to_s.singularize}_id"
        has_many_association = association.has_many_and_maybe_belongs_to_many?
        if has_many_association
          property = "#{property}s"
        end
        field_type = :association
      else
        column = Work.columns.find { |a| a.name == property.to_s }
        if column
          field_type = column.type
        elsif Work.instance_methods.include?(fieldname.to_sym) && Work.instance_methods.include?("#{fieldname}=".to_sym)
          field_type = Work.new.send(fieldname).class
        end
      end
    else
      property = objekt
      # assuming association...
      association = find_import_association_by_name(objekt)
      property = "#{property.pluralize}_attributes"
      complex_association = true
    end
    {fieldname: fieldname, field_type: field_type, objekt: objekt, property: property, association: association, has_many_association: has_many_association, complex_association: complex_association}
  end

  def set_import_file_snippet!(f = file)
    update_attribute(:import_file_snippet, workbook(f).sheet.table[0..24].to_csv)
  end

  def write
    read(import_file_to_workbook_table).collect { |a| a.save }
    collapse_all_generated_artists
    # just to be sure
    collection.works.reindex_async!
  end

  def find_keywords table_value, fields
    if fields.count != 1
      Rails.logger.warn "Keywords zoeken werkt alleen met 1 outputveld"
    else
      Rails.logger.debug "FIND KEYWORDS! #{fields.first}"
      analyzed_field_props = analyze_field_properties(fields.first)
      association = analyzed_field_props[:association]

      if association&.findable_by_name?
        options = association.klass.not_hidden.all
        names = options.collect { |a| a.name.to_s.downcase }
        keyword_finder = KeywordFinder::Keywords.new(names)
        table_values = keyword_finder.find_in(table_value.to_s.downcase)
        Rails.logger.debug "  find kerwords from string '#{table_value}' in: #{names.join(", ")}: #{table_values.join(", ")}"
        table_values
      end
    end
  end

  def lookup_artists! parameters
    artist = parameters["artists_attributes"] ? Artist.find_by(parameters["artists_attributes"][7382983741]) : nil
    if artist
      parameters.delete("artists_attributes")
      parameters[:artists] = [artist]
    elsif parameters["artists_attributes"] && parameters["artists_attributes"][7382983741]
      if "#{parameters["artists_attributes"][7382983741]["first_name"]}#{parameters["artists_attributes"][7382983741]["last_name"]}".strip.downcase == "onbekend"
        parameters.delete("artists_attributes")
        parameters["artist_unknown"] = true
      else
        parameters["artists_attributes"][7382983741]["import_collection_id"] = id
      end
    end
  end

  def prevent_non_child_colection_association_on_import!(parameters, collection_to_test)
    unless (collection_to_test == collection) || collection.child_collections_flattened.include?(collection_to_test)
      parameters[:collection_id] = nil
    end
  end

  def process_table_data_row(row)
    parameters = ActiveSupport::HashWithIndifferentAccess.new

    import_settings.each do |key, import_setting|
      cell = row[key.to_sym] || row[key]
      next if cell.nil?

      table_value = cell.value
      split_strategy = import_setting["split_strategy"].to_sym
      assign_strategy = import_setting["assign_strategy"].to_sym

      table_values = ImportCollection::Strategies::SplitStrategies.send(split_strategy, table_value)
      fields = import_setting["fields"] || []

      # Iterate over all fields and/or values selected for this value

      if fields.count > 0
        if split_strategy == :find_keywords
          table_values = find_keywords(table_values[1], fields)
        end

        field_value_indexes = [table_values.count, fields.count].max

        field_value_indexes.times do |index|
          field = fields[index] || fields.last

          field_props = analyze_field_properties(field)

          property = field_props[:property]
          complex_association = field_props[:complex_association]
          fieldname = field_props[:fieldname]
          parsed_value = parse_table_value(field_props, table_values[index])
          current_value = get_current_value(field_props, parameters)
          new_object_value = generate_new_value(field_props, assign_strategy, parsed_value, current_value)

          if complex_association
            parameters[property][7382983741][fieldname] = new_object_value
          else
            parameters[property] = new_object_value
          end
        end
      end
    end

    parameters.merge!({
      import_collection_id: id,
      imported_at: Time.now,
      external_inventory: external_inventory
    })

    parameters[:collection_id] ||= collection.id

    prevent_non_child_colection_association_on_import!(parameters, Collection.find(parameters[:collection_id]))

    lookup_artists!(parameters)

    new_obj = Work.new(parameters)

    Rails.logger.debug "  result: #{new_obj.inspect}"

    unless new_obj.valid?
      error_message = new_obj.errors.full_messages.to_sentence
      if new_obj.is_a? Work
        error_message = "Werk met inventarisnummer #{new_obj.stock_number} geeft fouten: #{error_message}"
      end
      raise ImportCollection::FailedImportError.new(error_message)
    end

    new_obj
  end

  def columns_for_select
    virtual_columns = [:purchase_price_currency, :tag_list]
    other_relations = {}
    import_associations.each do |import_association|
      if import_association.importable? && import_association.findable_by_name?
        virtual_columns << import_association.name
      elsif import_association.importable?
        other_relations[import_association.name] = filter_columns_ending_on_id(import_association.klass.column_names) - ignore_columns_generic
      end
    end

    other_relations.merge({
      work: (virtual_columns + filter_columns_ending_on_id(Work.column_names) - ignore_columns_generic - ignore_columns_work)
    })
  end

  private

  def get_current_value(field_props, parameters)
    property = field_props[:property]
    fieldname = field_props[:fieldname]
    has_many_association = field_props[:has_many_association]
    complex_association = field_props[:complex_association]
    if complex_association
      unless parameters[property]
        parameters[property] = {7382983741 => {fieldname => nil}}
      end
      parameters[property][7382983741][fieldname]
    else
      if has_many_association && !parameters[property]
        parameters[property] = []
      end
      parameters[property]
    end
  end

  def parse_table_value(field_props, table_value)
    association = field_props[:association]
    complex_association = field_props[:complex_association]
    if association && !complex_association
      corresponding_value = association.find_by_name(table_value)
      corresponding_value = corresponding_value.id if corresponding_value
      corresponding_value
    else
      table_value
    end
  end

  def generate_new_value(field_props, assign_strategy, corresponding_value, current_value)
    association = field_props[:association]
    has_many_association = field_props[:has_many_association]
    complex_association = field_props[:complex_association]
    field_type = field_props[:field_type]

    # Think of new value
    new_value = nil
    if association && !complex_association && has_many_association
      new_value = if assign_strategy == :replace
        [corresponding_value].compact
      else
        ([current_value] + [corresponding_value]).flatten.compact
      end
    elsif association && !complex_association && !has_many_association
      new_value = corresponding_value if corresponding_value || (assign_strategy == :replace)
    else
      if (field_type == :float) && (decimal_separator_with_fallback == ",") && corresponding_value
        corresponding_value = corresponding_value.to_s.tr(",", ".")
      end
      # hack against aggressive conversion to floats
      if (field_type == :string && corresponding_value && corresponding_value.to_s.start_with?(/TEXTVALUE/))
        corresponding_value = corresponding_value.sub("TEXTVALUE","")
      end
      if (assign_strategy == :replace) || ((assign_strategy == :first_then_join_rest) && (index == 0))
        new_value = corresponding_value
      elsif [:array, ActsAsTaggableOn::TagList, Array].include? field_type
        new_value = [current_value, corresponding_value].flatten.compact
      else
        separator = " "
        if (assign_strategy == :first_then_join_rest_separated) && (current_value.to_s.strip != "")
          separator = "; "
        end
        new_value = current_value ? "#{current_value}#{separator}#{corresponding_value}" : corresponding_value
      end
    end

    new_value
  end

  def import_associations
    # scoped_class = collection.send(a.name)
    @import_associations ||= Work.reflect_on_all_associations.collect { |a| ImportCollection::ClassAssociation.new({relation: a.macro, name: a.name, class_name: a.class_name, collection: collection}) }
  end

  def find_import_association_by_name(name)
    import_associations.find { |a| a.name == name.to_sym }
  end

  def filter_columns_ending_on_id column_names
    column_names.select { |a| !a.match(/(.*)_id/) }
  end

  def ignore_columns_work
    %w[artist_name_for_sorting appraisal_notice replacement_value_max replacement_value_min market_value_max market_value_min collection_locality_artist_involvements_texts_cache tag_list_cache artist_name_rendered valuation_on market_value replacement_value appraised_on tags geoname_summary_id work_set_types created_by_name]
  end

  def ignore_columns_generic
    %w[id created_at updated_at imported_at created_by_id lognotes external_inventory html_cache other_structured_data appraisee_type]
  end

end
