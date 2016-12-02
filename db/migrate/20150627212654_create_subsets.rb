class CreateSubsets < ActiveRecord::Migration
  def change
    create_table :subsets do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
