class ConvertAttributeIdIntoInt < ActiveRecord::Migration[7.1]
  def up
    change_column :collection_attributes, :attributed_id, "bigint USING attributed_id::bigint"
    change_column :o_auth_group_mappings, :collection_id, "bigint USING collection_id::bigint"
  end

  def down
    change_column :collection_attributes, :attributed_id, :string
    change_column :o_auth_group_mappings, :collection_id, :string
  end
end
