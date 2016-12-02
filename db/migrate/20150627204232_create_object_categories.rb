class CreateObjectCategories < ActiveRecord::Migration
  def change
    create_table :object_categories do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
