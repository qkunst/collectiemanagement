class CreateCollectionsStages < ActiveRecord::Migration[5.0]
  def change
    create_table :collections_stages do |t|
      t.integer :collection_id
      t.integer :stage_id
      t.datetime :completed_at

      t.timestamps
    end
  end
end
