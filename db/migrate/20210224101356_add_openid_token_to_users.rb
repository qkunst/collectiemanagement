class AddOpenidTokenToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :raw_open_id_token, :text
  end
end
