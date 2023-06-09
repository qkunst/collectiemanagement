class AddContactTypeToContacts < ActiveRecord::Migration[7.0]
  def change
    add_column :contacts, :contact_type, :string
  end
end
