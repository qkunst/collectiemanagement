# frozen_string_literal: true

class CreateFrameTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :frame_types do |t|
      t.string :name
      t.boolean :hide

      t.timestamps
    end

    [
      "Hout",
      "Hout goud",
      "Hout zilver",
      "Hout zwart",
      "Hout wit",
      "Hout groen",
      "Kunststof",
      "Aluminium",
      "Aluminium wit",
      "Aluminium paars/blauw",
      "Aluminium paars",
      "Aluminium blauw",
      "Aluminium zwart",
      "Aluminium groen",
      "Aluminium rood",
      "Aluminium goud",
      "Aluminium brons",
      "Multiplex",
      "Metaal",
      "Staal",
      "Baklijst"
    ].each do |name|
      FrameType.create(name: name)
    end

    add_column :works, :frame_type_id, :integer
  end
end
