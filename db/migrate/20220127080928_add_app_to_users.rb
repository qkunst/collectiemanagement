class AddAppToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :app, :boolean, default: false
  end
end
