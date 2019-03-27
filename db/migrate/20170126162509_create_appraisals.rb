# frozen_string_literal: true

class CreateAppraisals < ActiveRecord::Migration[5.0]
  def change
    create_table :appraisals do |t|
      t.date :appraised_on
      t.float :market_value
      t.float :replacement_value
      t.string :appraised_by
      t.integer :user_id
      t.text :reference

      t.timestamps
    end
  end
end
