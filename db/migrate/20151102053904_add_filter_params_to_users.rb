class AddFilterParamsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :filter_params, :text
  end
end
