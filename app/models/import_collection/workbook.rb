module ImportCollection::Workbook
  def workbook(f = file)
    if f.path
      @workbook ||= ::Workbook::Book.open(f.path)
    end
  end

  def import_file_to_workbook_table
    return nil if import_file_snippet.blank?

    offset = internal_header_row_offset
    table = ::Workbook::Table.new
    workbook.sheet.table.each_with_index do |row, index|
      if index >= offset
        table << row
      end
    end
    table
  end

  def internal_header_row_offset
    offset = 0
    offset += (header_row.to_i - 1) if header_row && (header_row.to_i > 0)
    offset
  end

  def import_file_snippet_to_workbook_table
    return nil if import_file_snippet.blank?

    offset = internal_header_row_offset
    table = ::Workbook::Table.new
    ::Workbook::Book.read(import_file_snippet, :csv, {converters: []}).sheet.table.each_with_index do |row, index|
      if index >= offset
        table << row
      end
    end
    table
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
        elsif Work.method_defined?(fieldname.to_sym) && Work.method_defined?(:"#{fieldname}=")
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

  def read(table = import_file_snippet_to_workbook_table)
    table.collect do |row|
      unless row.header?
        process_table_data_row(row)
      end
    end.compact
  end

  def write_table
    read(import_file_to_workbook_table).collect { |a| a.save }
  end

  def find_keywords table_value, fields
    if fields.count != 1
      Rails.logger.warn "Keywords zoeken werkt alleen met 1 outputveld"
    else
      Rails.logger.debug { "FIND KEYWORDS! #{fields.first}" }
      analyzed_field_props = analyze_field_properties(fields.first)
      association = analyzed_field_props[:association]

      if association&.findable_by_name?
        options = association.klass.not_hidden.all
        names = options.collect { |a| a.name.to_s.downcase }
        keyword_finder = KeywordFinder::Keywords.new(names)
        table_values = keyword_finder.find_in(table_value.to_s.downcase)
        Rails.logger.debug { "  find kerwords from string '#{table_value}' in: #{names.join(", ")}: #{table_values.join(", ")}" }
        table_values
      end
    end
  end

  def process_table_data_row(row)
    parameters = ActiveSupport::HashWithIndifferentAccess.new

    (import_settings || {}).each do |key, import_setting|
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
          raise ImportCollection::FailedImportError.new("Geen matchende waarde gevonden voor #{fields.to_sentence} (moet er een splits-strategie actief zijn?)") if table_values.nil?
        end

        field_value_indexes = [table_values.count, fields.count].max

        field_value_indexes.times do |index|
          field = fields[index] || fields.last

          field_props = analyze_field_properties(field)

          property = field_props[:property]
          next unless Work.new.methods.include? :"#{property}="

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
      imported_at: Time.current,
      updated_at: Time.current,
      external_inventory: external_inventory,
      old_data: row.to_hash.map { |k, v| [k, v&.value] }.to_h
    })

    parameters.delete(:old_data) if merge_data

    parameters[:collection_id] ||= collection.id
    collection = Collection.find(parameters[:collection_id])

    prevent_non_child_colection_association_on_import!(parameters, collection)

    lookup_artists!(parameters)

    new_obj = if merge_data
      collection.works_including_child_works.find_or_initialize_by({primary_key.to_sym => parameters[primary_key.to_sym]})
    else
      Work.new
    end

    new_obj.assign_attributes(parameters)

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
      if field_type == :string && corresponding_value&.to_s&.start_with?("TEXTVALUE")
        corresponding_value = corresponding_value.sub("TEXTVALUE", "")
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
end
