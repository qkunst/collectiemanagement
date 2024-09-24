class AddWeightToWorks < ActiveRecord::Migration[7.1]
  def change
    add_column :works, :weight, :float
  end
end
