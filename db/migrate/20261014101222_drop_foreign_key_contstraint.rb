class DropForeignKeyContstraint < ActiveRecord::Migration[8.1]
  def change
    remove_foreign_key "organisations", "auth_providers"
  end
end
