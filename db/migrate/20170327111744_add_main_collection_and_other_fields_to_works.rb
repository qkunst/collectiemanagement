class AddMainCollectionAndOtherFieldsToWorks < ActiveRecord::Migration[5.0]
  def change
    add_column :works, :main_collection, :boolean
    add_column :works, :image_rights, :boolean
    add_column :works, :publish, :boolean
  end
end
