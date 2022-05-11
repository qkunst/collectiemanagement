class AddOauthTokensToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :oauth_id_token, :string
    add_column :users, :oauth_refresh_token, :string
    add_column :users, :oauth_expires_at, :bigint
    add_column :users, :oauth_access_token, :string
  end
end
