class CreateWorkStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :work_statuses do |t|
      t.string :name
      t.boolean :hide, default: false

      t.timestamps
    end

    ["In gebruik", "Niet in gebruik", "Afgestoten", "Vermist"].each do |term|
      WorkStatus.create(name: term)
    end
  end
end
