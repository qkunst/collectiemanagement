# frozen_string_literal: true

class CreateDamageTypes < ActiveRecord::Migration[4.2]
  def change
    create_table :damage_types do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
