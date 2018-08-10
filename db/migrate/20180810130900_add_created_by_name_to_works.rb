class AddCreatedByNameToWorks < ActiveRecord::Migration[5.1]
  def change
    add_column :works, :created_by_name, :string
    User.all.each do |user|
      user.works_created.update_all(created_by_name: user.name)
    end
  end
end
