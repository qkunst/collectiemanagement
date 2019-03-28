# frozen_string_literal: true

class AddFilterParamsToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :filter_params, :text
  end
end
