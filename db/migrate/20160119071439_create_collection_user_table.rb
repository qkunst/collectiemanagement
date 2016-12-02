class CreateCollectionUserTable < ActiveRecord::Migration
  def change
    create_table :collections_users do |t|
      t.integer :user_id
      t.integer :collection_id
    end
  end
end
