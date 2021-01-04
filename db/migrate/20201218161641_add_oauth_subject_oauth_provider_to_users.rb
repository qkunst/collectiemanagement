class AddOauthSubjectOauthProviderToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :oauth_subject, :string
    add_column :users, :oauth_provider, :string
  end
end
