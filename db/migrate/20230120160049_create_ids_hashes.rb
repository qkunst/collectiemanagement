class CreateIdsHashes < ActiveRecord::Migration[7.0]
  def change
    create_table :ids_hashes do |t|
      t.string :hashed, null: false, index: {unique: true}
      t.text :ids_compressed, null: false

      t.timestamps
    end
  end
end
