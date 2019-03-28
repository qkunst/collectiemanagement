# frozen_string_literal: true

class CreateSubsets < ActiveRecord::Migration[4.2]
  def change
    create_table :subsets do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
