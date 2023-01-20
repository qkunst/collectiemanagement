class ConvertYamlToJson < ActiveRecord::Migration[7.0]
  def change
    Work.where.not(other_structured_data: nil).where("other_structured_data LIKE '---%'").each { |w| w.update_column(:other_structured_data, YAML.safe_load(w.read_attribute_before_type_cast(:other_structured_data))) }
  end
end
