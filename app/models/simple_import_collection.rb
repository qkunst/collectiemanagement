# == Schema Information
#
# Table name: import_collections
#
#  id                  :bigint           not null, primary key
#  file                :string
#  import_file_snippet :text
#  settings            :text
#  type                :string           default("ImportCollection")
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  collection_id       :bigint
#
class SimpleImportCollection < ImportCollection
  after_initialize :set_defaults
  DEFAULT_SETTINGS = {merge_data: true, primary_key: :stock_number, decimal_separator: ","}

  def set_defaults
    self.merge_data = DEFAULT_SETTINGS[:merge_data]
    self.primary_key ||= DEFAULT_SETTINGS[:primary_key]
    self.decimal_separator ||= DEFAULT_SETTINGS[:decimal_separator]
  end

  def import_settings
    @import_settings ||= workbook.sheet.table.header.to_symbols.map do |column_name|
      setters = Work.new.methods.select { |m| m.to_s.end_with?("=") }.map { |m| m.to_s[0..-2].to_sym }
      work_attributes = YAML.load_file(Rails.root.join("config", "locales", "custom.nl.yml"), aliases: true)["nl"]["activerecord"]["attributes"]["work"]
      work_attributes = work_attributes.select { |k, v| setters.include?(k.to_sym) }
      nl_map = work_attributes.map { |k, v| [::Workbook::Cell.value_to_sym(v), k] }.to_h
      attribute = nl_map[column_name] || column_name
      [column_name, {"fields" => ["work.#{attribute}"], "split_strategy" => "split_nothing", "assign_strategy" => "replace"}]
    end.to_h
  end

  def works
    []
  end
end
