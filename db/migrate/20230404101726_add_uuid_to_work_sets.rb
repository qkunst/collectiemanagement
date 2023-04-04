class AddUuidToWorkSets < ActiveRecord::Migration[7.0]
  def change
    add_column :work_sets, :uuid, :string, index: true, unique: true
    add_index :time_spans, :uuid
    WorkSet.all.each do |work_set|
      work_set.save
    end
  end
end
