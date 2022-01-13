class CreateContacts < ActiveRecord::Migration[6.1]
  def change
    create_table :contacts do |t|
      t.string :name
      t.text :address
      t.boolean :external
      t.string :url
      t.integer :collection_id

      t.timestamps
    end
  end
end
