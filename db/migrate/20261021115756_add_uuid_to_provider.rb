class AddUuidToProvider < ActiveRecord::Migration[8.1]
  def change
    add_column :auth_providers, :uuid, :string
  end
end
