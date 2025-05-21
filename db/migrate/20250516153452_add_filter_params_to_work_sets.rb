class AddFilterParamsToWorkSets < ActiveRecord::Migration[7.2]
  def change
    add_column :work_sets, :works_filter_params, :json
  end
end
