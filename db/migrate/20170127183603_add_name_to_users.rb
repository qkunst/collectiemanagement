class AddNameToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :name, :string
    User.all.each do |a|
      a.name = a.email.split("@")[0].capitalize
      a.save
    end
  end
end
