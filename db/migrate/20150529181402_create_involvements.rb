# frozen_string_literal: true

class CreateInvolvements < ActiveRecord::Migration[4.2]
  def change
    create_table :involvements do |t|
      t.string :name
      t.string :city
      t.string :country
      t.string :type

      t.timestamps null: false
    end
  end
end
