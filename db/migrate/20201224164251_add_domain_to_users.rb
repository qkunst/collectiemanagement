class AddDomainToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :domain, :string
  end
end
