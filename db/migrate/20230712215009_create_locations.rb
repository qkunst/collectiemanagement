class CreateLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :locations do |t|
      t.string :name
      t.string :address
      t.float :lat
      t.float :lon
      t.integer :collection_id

      t.timestamps
    end
  end
end
