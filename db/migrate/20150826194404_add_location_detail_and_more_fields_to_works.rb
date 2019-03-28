# frozen_string_literal: true

class AddLocationDetailAndMoreFieldsToWorks < ActiveRecord::Migration[4.2]
  def change
    add_column :works, :location_detail, :string
    add_column :works, :valuation_on, :date
    add_column :works, :internal_comments, :text
  end
end
