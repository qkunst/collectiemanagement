class AddIndexOnClientIdToAuthProviders < ActiveRecord::Migration[8.1]
  def change
    add_index :auth_providers, [:client_id, :strategy]
    add_index :auth_providers, :uuid
  end
end
