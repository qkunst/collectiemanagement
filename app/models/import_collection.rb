# frozen_string_literal: true

class ImportCollection < ApplicationRecord
  class ImportError < StandardError; end

  include ImportCollection::Json
  include ImportCollection::Workbook

  belongs_to :collection
  has_many :artists
  has_many :works

  store :settings, accessors: [:header_row, :import_settings, :decimal_separator, :external_inventory]

  mount_uploader :file, TableUploader

  def decimal_separator_with_fallback
    decimal_separator || ","
  end

  def import_setting_for field
    settings = import_settings && import_settings[field.to_s] ? import_settings[field.to_s] : {}
    {"fields" => [], "split_strategy" => "split_nothing", "assign_strategy" => "append"}.merge(settings)
  end

  def base_collection
    @base_collection ||= collection.base_collection
  end

  def collapse_all_generated_artists
    artists.collapse_by_name!
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

  def write
    remove_works_imported_with_this_importer

    if json?
      write_json
    else
      write_table
    end
    collapse_all_generated_artists
    # just to be sure
    # collection.works.reindex_async!
  end

  def prevent_non_child_colection_association_on_import!(parameters, collection_to_test)
    unless (collection_to_test == collection) || collection.child_collections_flattened.include?(collection_to_test)
      parameters[:collection_id] = nil
    end
  end

  def remove_works_imported_with_this_importer
    Work.where(import_collection_id: self.id).quick_destroy_all
  end

  private

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
    %w[artist_name_for_sorting appraisal_notice replacement_value_max replacement_value_min market_value_max market_value_min collection_locality_artist_involvements_texts_cache tag_list_cache artist_name_rendered valuation_on market_value replacement_value appraised_on tags geoname_summary_id work_set_types created_by_name import_collection]
  end

  def ignore_columns_generic
    %w[id created_at updated_at imported_at created_by_id lognotes external_inventory html_cache other_structured_data appraisee_type]
  end

end
