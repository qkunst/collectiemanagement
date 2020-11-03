# frozen_string_literal: true

class CreateStages < ActiveRecord::Migration[5.0]
  def change
    create_table :stages do |t|
      t.string :name
      t.integer :actual_stage_id
      t.integer :previous_stage_id

      t.timestamps
    end
    s1 = Stage.create(name: "Inventarisatie")
    s2 = Stage.create(name: "Waardering", previous_stage: s1)
    s3 = Stage.create(name: "Advies", previous_stage: s2)
    s4 = Stage.create(name: "Besluitvorming", previous_stage: s3)
    s5a = Stage.create(name: "Ontzamelen", previous_stage: s4)
    s5b = Stage.create(name: "Inrichten", previous_stage: s4)
    s5c = Stage.create(name: "Kunst in opdracht", previous_stage: s4)
    s6 = Stage.create(name: "Oplevering", previous_stage: s5a)
    Stage.create(name: "Oplevering", previous_stage: s5b, actual_stage: s6)
    Stage.create(name: "Oplevering", previous_stage: s5c, actual_stage: s6)
    Stage.create(name: "Beheer", previous_stage: s6)
  end
end
