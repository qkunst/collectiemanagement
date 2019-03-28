# frozen_string_literal: true

class CreateCollectionUserTable < ActiveRecord::Migration[4.2]
  def change
    create_table :collections_users do |t|
      t.integer :user_id
      t.integer :collection_id
    end
  end
end
