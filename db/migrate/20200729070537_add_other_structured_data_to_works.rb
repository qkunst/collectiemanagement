class AddOtherStructuredDataToWorks < ActiveRecord::Migration[5.2]
  def change
    add_column :works, :other_structured_data, :text
  end
end
