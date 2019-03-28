# frozen_string_literal: true

class CreateMedia < ActiveRecord::Migration[4.2]
  def change
    create_table :media do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
