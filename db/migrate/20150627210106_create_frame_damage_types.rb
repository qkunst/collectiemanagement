# frozen_string_literal: true

class CreateFrameDamageTypes < ActiveRecord::Migration
  def change
    create_table :frame_damage_types do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
