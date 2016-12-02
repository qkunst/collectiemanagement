class ImportCollectionClassAssociation
  attr_accessor :relation, :name, :class_name

  def initialize(options={})
    options.each do |k,v|
      self.send("#{k}=",v)
    end
  end

  def klass
    eval(class_name)
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
    unless ["PaperTrail::Version","Currency"].include? class_name
      return true
    end
    return false
  end

  def find_by_name name
    if implements_find_by_name?
      klass.find_by_name(name)
    elsif has_name_column?
      klass.where(klass.arel_table[:name].matches(name)).first
    end
  end
end

class ImportCollection < ActiveRecord::Base
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

  def import_file_snippet_to_workbook_table
    return nil if import_file_snippet.nil? or import_file_snippet.empty?
    offset = 0
    offset += (header_row.to_i - 1) if header_row
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
    offset = 0
    offset += (header_row.to_i - 1) if header_row
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
    # TODO: to be replaced by reading the entire workbook again
    debug = false

    table.each do |row|
      unless row.header?
        parameters = {}

        import_settings.each do |key, import_setting|
          next if row[key].nil?
          error = nil

          table_value = row[key].value
          split_strategy = import_setting["split_strategy"].to_sym
          assign_strategy = import_setting["assign_strategy"].to_sym

          table_values = ImportCollection.split_strategies[split_strategy].call(table_value)
          fields = import_setting["fields"] ? import_setting["fields"] : []

          # Iterate over all fields and/or values selected for this value

          field_value_indexes = 0

          puts "Key: #{key}" if debug

          if fields.count > 0
            if fields.count == 1 and split_strategy == :find_keywords
              puts "FIND KEYWORDS! #{fields.first}" if debug
              analyzed_field_props = analyze_field_properties(fields.first)
              association = analyzed_field_props[:association]
              p analyzed_field_props
              if association and association.findable_by_name?
                options = association.klass.not_hidden.all
                names = options.collect{|a| a.name.to_s.downcase}
                keyword_finder = KeywordFinder::Keywords.new(names)
                search_string = table_values[1]
                table_values = keyword_finder.find_in(search_string.to_s.downcase)
                puts "  find kerwords from string '#{search_string}' in: #{names.join(", ")}: #{table_values.join(", ")}" if debug
              end
            elsif split_strategy == :find_keywords
              error = "Keywords zoeken werkt alleen met 1 outputveld"
            end

            field_value_indexes = table_values.count > fields.count ? table_values.count : fields.count

            puts table_values

            field_value_indexes.times do |index|
              # puts index
              field = fields[index] ? fields[index] : fields.last

              analyzed_field_props = analyze_field_properties(field)

              property = analyzed_field_props[:property]
              association = analyzed_field_props[:association]
              has_many_association = analyzed_field_props[:has_many_association]
              complex_association = analyzed_field_props[:complex_association]
              fieldname = analyzed_field_props[:fieldname]
              objekt = analyzed_field_props[:objekt]
              field_type = analyzed_field_props[:field_type]

              puts "#{field} #{index}: #{property} (#{association.klass if association}) (has may? #{has_many_association}; copmlex? #{complex_association}, field_type: #{field_type})" if debug

              current_value = nil

              # Get current value: preparing object

              if complex_association
                # TODO: complex associations doesn't implement has many properly...
                #       forget for now, implemented as single
                unless parameters[property]
                  parameters[property] = { 7382983741 => {fieldname => nil}}
                end
                current_value = parameters[property][7382983741][fieldname]
              else
                if has_many_association and !parameters[property]
                  parameters[property] = [ ]
                end
                current_value = parameters[property]
              end

              # Get the value from the table

              corresponding_value = nil
              corresponding_table_value = table_values[index]
              if association and !complex_association
                corresponding_value = association.find_by_name(corresponding_table_value)
                corresponding_value = corresponding_value.id if corresponding_value
              else
                corresponding_value = corresponding_table_value
              end

              puts "  corresponding_value: #{corresponding_value}" if debug

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
                  corresponding_value = corresponding_value.to_s.gsub(",",".")
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

              puts "  new_value: #{new_value}" if debug

              # Set the new value

              if complex_association
                # TODO: complex associations doesn't implement has many properly...
                #       forget for now, implemented as single (currently only applicable to 'authors')
                parameters[property][7382983741][fieldname] = new_value
              else
                parameters[property] = new_value
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
        # prefent regeneration of artists
        # raise parameters
        artist = parameters["artists_attributes"] ? Artist.find_by(parameters["artists_attributes"][7382983741]) : nil
        if artist
          parameters.delete("artists_attributes")
          parameters[:artists] = [artist]
        elsif parameters["artists_attributes"] and parameters["artists_attributes"][7382983741]
          parameters["artists_attributes"][7382983741]["import_collection_id"] = self.id
        end
        result << ImportCollection.import_type.new(parameters)
      end
    end
    result
  end

  def collapse_all_generated_artists
    artists.collapse_by_name
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
      @@import_associations ||= import_type.reflect_on_all_associations.collect{|a| ImportCollectionClassAssociation.new({relation: a.macro, name: a.name, class_name: a.class_name}) }
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

    def split_strategies
      {
        split_nothing: ->(field){ [field] },
        split_space: ->(field){ field.to_s.split(/[\s\n]/).collect{|a| a.strip == "" ? nil : a.strip}.compact },
        split_comma: ->(field){ field.to_s.split(/\,/).collect{|a| a.strip == "" ? nil : a.strip}.compact },
        split_natural: ->(field){ field.to_s.split(/\sen\s|\,/).collect{|a| a.strip == "" ? nil : a.strip}.compact },
        split_cross: ->(field){ field.to_s.split(/[x\*]/i).collect{|a| a.strip == "" ? nil : a.strip}.compact },
        find_keywords: ->(field){ [:find_keywords, field]}
      }
    end

    def assign_strategies
      {
        replace: ->(fields, values){ values.each_with_index{|value,index| update_field(fields[index], value) } },
        append: ->(fields, values){ },
        # append_with_fieldname_prefix: ->(fields, values){ },
        first_then_join_rest: ->(fields, values){ values.each_with_index{|value,index| update_field(fields[index], value) } },
        first_then_join_rest_separated: ->(fields, values){ values.each_with_index{|value,index| update_field(fields[index], value) } }
      }
    end
  end

end


