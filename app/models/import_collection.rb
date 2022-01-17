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

  def json?
    file.content_type == "application/json" || import_file_snippet == nil && file&.file&.file&.ends_with?(".json")
  end

  def set_import_file_snippet!(f = file)
    if f.content_type == "application/json"
      update_attribute(:import_file_snippet, nil)
    else
      update_attribute(:import_file_snippet, workbook(f).sheet.table[0..24].to_csv)
    end
  end

  def write_table
    read(import_file_to_workbook_table).collect { |a| a.save }
  end

  def write_json
    Work.where(import_collection_id: self.id).destroy_all
    json = JSON.parse(file.read)
    json.each do |work_data|
      work = Work.new(
        stock_number: work_data["stock_number"],
        alt_number_1: work_data["alt_number_1"],
        alt_number_2: work_data["alt_number_2"],
        alt_number_3: work_data["alt_number_3"],
        title: work_data["title"],
        title_unknown: work_data["title_unknown"],
        description: work_data["description"],
        object_creation_year: work_data["object_creation_year"],
        object_creation_year_unknown: work_data["object_creation_year_unknown"],
        print: work_data["print"],
        print_unknown: work_data["print_unknown"],
        frame_height: work_data["frame_height"],
        frame_width: work_data["frame_width"],
        frame_depth: work_data["frame_depth"],
        frame_diameter: work_data["frame_diameter"],
        height: work_data["height"],
        width: work_data["width"],
        depth: work_data["depth"],
        diameter: work_data["diameter"],
        public_description: work_data["public_description"],
        abstract_or_figurative: work_data["abstract_or_figurative"],
        location_detail: work_data["location_detail"],
        location: work_data["location"],
        location_floor: work_data["location_floor"],
        internal_comments: work_data["internal_comments"],
        inventoried: work_data["inventoried"],
        refound: work_data["refound"],
        new_found: work_data["new_found"],
        geoname_id: work_data["geoname_id"],
        imported_at: Time.now,
        import_collection_id: self.id,
        artist_unknown: work_data["artist_unknown"],
        signature_comments: work_data["signature_comments"],
        no_signature_present: work_data["no_signature_present"],
        information_back: work_data["information_back"],
        other_comments: work_data["other_comments"],
        grade_within_collection: work_data["grade_within_collection"],
        entry_status: work_data["entry_status"],
        entry_status_description: work_data["entry_status_description"],
        medium_comments: work_data["medium_comments"],
        main_collection: work_data["main_collection"],
        image_rights: work_data["image_rights"],
        publish: work_data["publish"],
        permanently_fixed: work_data["permanently_fixed"],
        condition_work_comments: work_data["condition_work_comments"],
        condition_frame_comments: work_data["condition_frame_comments"],
        source_comments: work_data["source_comments"],
        purchase_price: work_data["purchase_price"],
        purchased_on: work_data["purchased_on"],
        purchase_year: work_data["purchase_year"],
        selling_price: work_data["selling_price"],
        minimum_bid: work_data["minimum_bid"],
        market_value_max: work_data["market_value_max"],
        market_value_min: work_data["market_value_min"],
        replacement_value_min: work_data["replacement_value_min"],
        replacement_value_max: work_data["replacement_value_max"],
        minimum_bid: work_data["minimum_bid"],
        selling_price: work_data["selling_price"],
        valuation_on: work_data["valuation_on"],
        market_value: work_data["market_value"],
        replacement_value: work_data["replacement_value"],

        selling_price_minimum_bid_comments: work_data["selling_price_minimum_bid_comments"],
        id: work_data["id"],
        #collection_branch_names: work_data["collection_branch_names"],
      )
      work.collection = collection

      # Photo's
      oringal_photo_front = work_data["photo_front"]&.[]("original")
      oringal_photo_back = work_data["photo_back"]&.[]("original")
      oringal_photo_detail_1 = work_data["photo_detail_1"]&.[]("original")
      oringal_photo_detail_2 = work_data["photo_detail_2"]&.[]("original")

      work.photo_front = URI.open(oringal_photo_front) if oringal_photo_front
      work.photo_back = URI.open(oringal_photo_back) if oringal_photo_back
      work.photo_detail_1 = URI.open(oringal_photo_detail_1) if oringal_photo_detail_1
      work.photo_detail_2 = URI.open(oringal_photo_detail_2) if oringal_photo_detail_2

      cluster_data = work_data["cluster"]
      if cluster_data
        work.cluster = Cluster.where(name: cluster_data["name"], collection: collection.base_collection.collection_including_child_collections).first || Cluster.create(name: cluster_data["name"], collection: collection.base_collection)
      end

      owner_data = work_data["owner"]
      if owner_data
        work.cluster = Owner.where(name: owner_data["name"], collection: collection.base_collection.collection_including_child_collections).first || Owner.create(name: owner_data["name"], collection: collection.base_collection, creating_artist: owner_data["creating_artist"])
      end

      purchase_price_currency = work_data["purchase_price_currency_iso_4217_code"]
      if purchase_price_currency
        work.purchase_price_currency = Currency.find_or_create_by(iso_4217_code: purchase_price_currency).first
      end

      work_data["object_categories"].each do |object_category|
        work.object_categories << ObjectCategory.find_or_create_by(name: object_category["name"])
      end
      if work_data["placeability"]
        work.placeability << Placeability.find_or_create_by(name: work_data["placeability"]["name"])
      end
      if work_data["balance_category"]
        work.balance_category = BalanceCategory.find_or_create_by(name: work_data["balance_category"]["name"])
      end
      if work_data["style"]
        work.style = Style.find_or_create_by(name: work_data["style"]["name"])
      end
      if work_data["medium"]
        work.medium = Medium.find_or_create_by(name: work_data["medium"]["name"])
      end
      if work_data["condition_work"]
        work.condition_work = Condition.find_or_create_by(name: work_data["condition_work"]["name"])
      end
      if work_data["condition_frame"]
        work.condition_frame = Condition.find_or_create_by(name: work_data["condition_frame"]["name"])
      end
      if work_data["frame_type"]
        work.frame_type = FrameType.find_or_create_by(name: work_data["frame_type"]["name"])
      end
      if work_data["subset"]
        work.subset = Subset.find_or_create_by(name: work_data["subset"]["name"])
      end
      if work_data["work_status"]
        work.work_status = WorkStatus.find_or_create_by(name: work_data["work_status"]["name"])
      end



      # HAS MANY
      work_data["appraisals"].each do |appraisal_data|
        work.appraisals << Appraisal.create(appraisal_data)
      end
      work_data["techniques"].each do |technique|
        work.techniques << Technique.find_or_create_by(name: technique["name"])
      end
      work_data["artists"].each do |artist_data|
        artist = if artist_data["rkd_artist_id"]
          Artist.find_by(rkd_artist_id: artist_data["rkd_artist_id"])
        else
          Artist.find_or_create_by(
            artist_name: artist_name,
            year_of_death: year_of_death,
            year_of_birth: year_of_birth,
            last_name: last_name,
            prefix: prefix,
            first_name: first_name
          )
        end
        work.artists << artist
      end
      work_data["themes"].each do |theme|
        work.themes << Theme.find_by(name: theme["name"], collection_id: nil) || Theme.find_or_create_by(name: theme["name"], collection_id: collection.base_collection)
      end
      work_data["damage_types"].each do |damage_type|
        work.damage_types << DamageType.find_or_create_by(name: damage_type["name"])
      end
      work_data["frame_damage_types"].each do |frame_damage_type|
        work.frame_damage_type << FrameDamageType.find_or_create_by(name: frame_damage_type["name"])
      end
      work_data["sources"].each do |source|
        work.sources << Source.find_or_create_by(name: source["name"])
      end
      work_data["work_sets"].each do |work_set|
        work_set_type = WorkSetType.find_or_create_by(name: work_set["work_set_type"]["name"], count_as_one: work_set["work_set_type"]["count_as_one"], appraise_as_one: work_set["work_set_type"]["appraise_as_one"])
        work.work_sets << WorkSet.find_or_create_by(work_set_type: work_set_type, identification_number: work_set["identification_number"], appraisal_notice: work_set["appraisal_notice"], comment: work_set["comment"])
      end

      # TODO:
      # has_and_belongs_to_many :attachments
      # has_and_belongs_to_many :library_items
      # has_many :messages, as: :subject_object
      # has_many :time_spans, as: :subject
      #

      work.save
    end
    # raise
  end

  def write
    if json?
      write_json
    else
      write_table
    end
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
