class ImportCollection < ApplicationRecord
  belongs_to :collection
  has_many :artists
  has_many :works

  store :settings, accessors: [:header_row, :import_settings, :decimal_separator, :external_inventory]

  mount_uploader :file, TableUploader

  def workbook(f=file)
    if f.path
      @workbook ||= Workbook::Book.open(f.path)
    end
  end

  def decimal_separator_with_fallback
    decimal_separator ? decimal_separator : ","
  end

  def import_setting_for field
    settings = (import_settings and import_settings[field.to_s]) ? import_settings[field.to_s] : {}
    {"fields" => [], "split_strategy" => "split_nothing", "assign_strategy" => "append"}.merge(settings)
  end

  def internal_header_row_offset
    offset = 0
    offset += (header_row.to_i - 1) if header_row and header_row.to_i > 0
    offset
  end

  def import_file_snippet_to_workbook_table
    return nil if import_file_snippet.nil? or import_file_snippet.empty?
    offset = internal_header_row_offset
    table = Workbook::Table.new()
    Workbook::Book.read(import_file_snippet, :csv, {converters: [ ]}).sheet.table.each_with_index do |row, index|
      if index >= offset
        table << row
      end
    end
    table
  end

  def import_file_to_workbook_table
    return nil if import_file_snippet.nil? or import_file_snippet.empty?
    offset = internal_header_row_offset
    table = Workbook::Table.new()
    workbook.sheet.table.each_with_index do |row, index|
      if index >= offset
        table << row
      end
    end
    table
  end

  def read(table=import_file_snippet_to_workbook_table)
    result = [ ]

    table.each do |row|
      unless row.header?
        result << process_table_data_row(row)
      end
    end
    # Rails.logger.debug "  result: #{result.inspect}"
    result
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

    if objekt == ImportCollection.import_type_symbolized.to_s
      association = ImportCollection.find_import_association_by_name(fieldname.to_sym)
      property = fieldname
      if association
        property = "#{property.to_s.singularize}_id"
        has_many_association = association.has_many_and_maybe_belongs_to_many?
        if has_many_association
          property = "#{property}s"
        end
        field_type = :association
      else
        field_type = Work.columns.select{|a| a.name == property.to_s}.first.type
      end
    else
      property = objekt
      # assuming association...
      association = ImportCollection.find_import_association_by_name(objekt)
      #has_many_association = association.has_many_and_maybe_belongs_to_many?
      property = property.pluralize# if has_many_association
      property = "#{property}_attributes"
      complex_association = true
    end
    return {fieldname: fieldname, field_type: field_type, objekt: objekt, property: property, association: association, has_many_association: has_many_association, complex_association: complex_association}
  end

  def set_import_file_snippet!(f=file)
    self.update_attribute(:import_file_snippet, workbook(f).sheet.table[0..24].to_csv)
  end

  def write
    read(import_file_to_workbook_table).collect{|a| a.save}
    collapse_all_generated_artists
    # just to be sure
    collection.works.reindex!
  end

  def process_table_data_row(row)
    parameters = {}

    import_settings.each do |key, import_setting|
      next if row[key].nil?
      error = nil

      table_value = row[key].value
      split_strategy = import_setting["split_strategy"].to_sym
      assign_strategy = import_setting["assign_strategy"].to_sym

      table_values = ImportCollection::Strategies::SplitStrategies.send(split_strategy, table_value)
      fields = import_setting["fields"] ? import_setting["fields"] : []

      # Iterate over all fields and/or values selected for this value


      field_value_indexes = 0

      Rails.logger.debug "Key: #{key}"

      if fields.count > 0
        if fields.count == 1 and split_strategy == :find_keywords
          Rails.logger.debug "FIND KEYWORDS! #{fields.first}"
          analyzed_field_props = analyze_field_properties(fields.first)
          association = analyzed_field_props[:association]
          # p analyzed_field_props
          if association and association.findable_by_name?
            options = association.klass.not_hidden.all
            names = options.collect{|a| a.name.to_s.downcase}
            keyword_finder = KeywordFinder::Keywords.new(names)
            search_string = table_values[1]
            table_values = keyword_finder.find_in(search_string.to_s.downcase)
            Rails.logger.debug "  find kerwords from string '#{search_string}' in: #{names.join(", ")}: #{table_values.join(", ")}"
          end
        elsif split_strategy == :find_keywords
          Rails.logger.debug "Keywords zoeken werkt alleen met 1 outputveld"
        end

        field_value_indexes = [table_values.count, fields.count].max

        field_value_indexes.times do |index|
          # puts index
          field = fields[index] ? fields[index] : fields.last

          field_props = analyze_field_properties(field)

          property = field_props[:property]
          association = field_props[:association]
          has_many_association = field_props[:has_many_association]
          complex_association = field_props[:complex_association]
          fieldname = field_props[:fieldname]
          objekt = field_props[:objekt]
          field_type = field_props[:field_type]

          Rails.logger.debug "#{field} #{index}: #{property} (#{association.klass if association}) (has may? #{has_many_association}; copmlex? #{complex_association}, field_type: #{field_type})"

          current_value = nil

          # Get current value: preparing object

          # Get the value from the table

          current_value = get_current_value(field_props, parameters)
          parsed_value = parse_table_value(field_props, table_values[index])
          new_object_value = generate_new_value(field_props, assign_strategy, parsed_value, current_value)

          # Set the new value

          if complex_association
            parameters[property][7382983741][fieldname] = new_object_value
          else
            parameters[property] = new_object_value
          end

        end
      end
    end

    parameters.merge!({
      collection_id: collection.id,
      import_collection_id: self.id,
      imported_at: Time.now,
      external_inventory: self.external_inventory
    })
    # prevent regeneration of artists
    # raise parameters
    artist = parameters["artists_attributes"] ? Artist.find_by(parameters["artists_attributes"][7382983741]) : nil
    if artist
      parameters.delete("artists_attributes")
      parameters[:artists] = [artist]
    elsif parameters["artists_attributes"] and parameters["artists_attributes"][7382983741]
      parameters["artists_attributes"][7382983741]["import_collection_id"] = self.id
    end
    new_obj = ImportCollection.import_type.new(parameters)

    Rails.logger.debug "  result: #{new_obj.inspect}"
    if !new_obj.valid?
      error_message = new_obj.errors.full_messages.to_sentence
      if new_obj.is_a? Work
        error_message = "Werk met inventarisnummer #{new_obj.stock_number} geeft fouten: #{error_message}"
      end
      raise ImportCollection::FailedImportError.new(error_message)
    end

    return new_obj
  end

  private

  def get_current_value(field_props, parameters)
    property = field_props[:property]
    fieldname = field_props[:fieldname]
    has_many_association = field_props[:has_many_association]
    complex_association = field_props[:complex_association]
    if complex_association
      unless parameters[property]
        parameters[property] = { 7382983741 => {fieldname => nil}}
      end
      return parameters[property][7382983741][fieldname]
    else
      if has_many_association and !parameters[property]
        parameters[property] = [ ]
      end
      return parameters[property]
    end
  end

  def parse_table_value(field_props, table_value)
    association = field_props[:association]
    complex_association = field_props[:complex_association]
    if association and !complex_association
      corresponding_value = association.find_by_name(table_value)
      corresponding_value = corresponding_value.id if corresponding_value
      return corresponding_value
    else
      return table_value
    end
  end

  def generate_new_value(field_props, assign_strategy, corresponding_value, current_value)
    association = field_props[:association]
    has_many_association = field_props[:has_many_association]
    complex_association = field_props[:complex_association]
    fieldname = field_props[:fieldname]
    objekt = field_props[:objekt]
    field_type = field_props[:field_type]

    # Think of new value
    new_value = nil
    if association and !complex_association and has_many_association
      if assign_strategy == :replace
        new_value = [corresponding_value].compact
      else
        new_value = ([current_value] + [corresponding_value]).flatten.compact
      end
    elsif association and !complex_association and !has_many_association
      new_value = corresponding_value if (corresponding_value or assign_strategy == :replace)
    else
      if field_type == :float and decimal_separator_with_fallback == "," and corresponding_value
        corresponding_value = corresponding_value.to_s.tr(",",".")
      end
      if assign_strategy == :replace or (assign_strategy == :first_then_join_rest and index == 0)
        new_value = corresponding_value
      else
        separator = " "
        if assign_strategy == :first_then_join_rest_separated and current_value.to_s.strip != ""
          separator = "; "
        end
        new_value = current_value ? "#{current_value}#{separator}#{corresponding_value}" : corresponding_value
      end
    end

    new_value
  end

  class << self
    def ignore_columns
      ["id","created_at","updated_at","imported_at","collection_id", "created_by_id", "lognotes", "external_inventory"]
    end

    def filter_columns_ending_on_id column_names
      column_names.select{|a| !a.match(/(.*)_id/) }
    end

    def import_type
      Work
    end

    def import_type_symbolized
      import_type.to_s.downcase.to_sym
    end

    def import_associations
      @@import_associations ||= import_type.reflect_on_all_associations.collect{|a| ImportCollection::ClassAssociation.new({relation: a.macro, name: a.name, class_name: a.class_name}) }
    end

    def find_import_association_by_name(name)
      self.import_associations.select{|a| a.name == name.to_sym}.first
    end

    def columns_for_select
      virtual_columns = [ ]
      other_relations = {}
      import_associations.each do |import_association|
        if import_association.importable? && import_association.findable_by_name?
          virtual_columns << import_association.name
        elsif import_association.importable?
          other_relations[import_association.name] = filter_columns_ending_on_id(import_association.klass.column_names)-ignore_columns
        end
      end

      return other_relations.merge({
        import_type_symbolized => virtual_columns+filter_columns_ending_on_id(Work.column_names)-ignore_columns
      })
    end




  end

end