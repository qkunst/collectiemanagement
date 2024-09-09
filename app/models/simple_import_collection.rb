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
  def import_settings
    @import_settings ||= workbook.sheet.table.header.to_symbols.map do |column_name|
      work_attributes = YAML.load_file(Rails.root.join("config", "locales", "custom.nl.yml"), aliases: true)["nl"]["activerecord"]["attributes"]["work"]
      nl_map = work_attributes.map { |k, v| [::Workbook::Cell.value_to_sym(v), k] }.to_h
      attribute = nl_map[column_name] || column_name
      [column_name, {"fields" => ["work.#{attribute}"], "split_strategy" => "split_nothing", "assign_strategy" => "replace"}]
    end.to_h
  end
end
