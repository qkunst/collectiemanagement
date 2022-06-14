class AddRemoteDataToContacts < ActiveRecord::Migration[6.1]
  def change
    add_column :contacts, :remote_data, :text
  end
end
