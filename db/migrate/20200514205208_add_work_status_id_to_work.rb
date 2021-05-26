# frozen_string_literal: true

class AddWorkStatusIdToWork < ActiveRecord::Migration[5.2]
  def change
    add_column :works, :work_status_id, :integer
  end
end
