# frozen_string_literal: true

class AddPurchaseDateToWorks < ActiveRecord::Migration[5.0]
  def change
    add_column :works, :purchased_on, :date
    add_column :appraisals, :work_id, :integer
  end
end
