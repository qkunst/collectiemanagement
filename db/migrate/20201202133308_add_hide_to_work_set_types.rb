class AddHideToWorkSetTypes < ActiveRecord::Migration[6.0]
  def change
    add_column :work_set_types, :hide, :boolean

    WorkSetType.create(name: "Meerluik", count_as_one: true, appraise_as_one: true)
    WorkSetType.create(name: "Mogelijk zelfde vervaardiger", count_as_one: false, appraise_as_one: false)
  end
end
