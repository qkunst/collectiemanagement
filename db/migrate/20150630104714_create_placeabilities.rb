class CreatePlaceabilities < ActiveRecord::Migration
  def change
    create_table :placeabilities do |t|
      t.string :name, required: true
      t.integer :order
      t.boolean :hide, default: false

      t.timestamps null: false
    end
    add_column :works, :placeability_id, :integer
  end
end