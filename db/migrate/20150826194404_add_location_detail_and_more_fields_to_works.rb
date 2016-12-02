class AddLocationDetailAndMoreFieldsToWorks < ActiveRecord::Migration
  def change
    add_column :works, :location_detail, :string
    add_column :works, :valuation_on, :date
    add_column :works, :internal_comments, :text
  end
end
