class CreateOAuthGroupMappings < ActiveRecord::Migration[6.1]
  def change
    create_table :o_auth_group_mappings do |t|
      t.string :issuer
      t.string :value_type
      t.string :value
      t.string :collection_id
      t.string :role

      t.timestamps
    end
  end
end
