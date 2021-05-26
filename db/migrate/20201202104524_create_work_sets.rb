# frozen_string_literal: true

class CreateWorkSets < ActiveRecord::Migration[6.0]
  def change
    create_table :work_sets do |t|
      t.integer :work_set_type_id
      t.string :identification_number

      t.timestamps
    end

    create_join_table :works, :work_sets
  end
end
