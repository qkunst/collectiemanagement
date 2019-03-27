# frozen_string_literal: true

class ChangeCreatedByToIntegerOnWorks < ActiveRecord::Migration
  def change
    remove_column :works, :created_by
    add_column :works, :created_by_id, :integer
  end
end
