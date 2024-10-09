class AddFormatWeightDescriptionToWorks < ActiveRecord::Migration[7.1]
  def change
    add_column :works, :dimension_weight_description, :string
  end
end
