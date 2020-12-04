class CreateWorkSetTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :work_set_types do |t|
      t.string :name
      t.boolean :count_as_one
      t.boolean :appraise_as_one

      t.timestamps
    end
  end
end
