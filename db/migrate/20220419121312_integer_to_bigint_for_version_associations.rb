class IntegerToBigintForVersionAssociations < ActiveRecord::Migration[6.1]
  def change
    change_column :version_associations, :foreign_key_id, :bigint
  end
end
