# frozen_string_literal: true

class CreateClusters < ActiveRecord::Migration[4.2]
  def change
    create_table :clusters do |t|
      t.integer :collection_id
      t.string :name
      t.text :description

      t.timestamps null: false
    end
    add_column :works, :cluster_id, :integer
  end
end
