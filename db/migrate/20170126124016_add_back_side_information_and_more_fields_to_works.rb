class AddBackSideInformationAndMoreFieldsToWorks < ActiveRecord::Migration[5.0]
  def change
    add_column :works, :public_description, :text
    add_column :works, :location_floor, :string
  end
end