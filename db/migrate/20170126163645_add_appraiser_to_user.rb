# frozen_string_literal: true

class AddAppraiserToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :appraiser, :boolean
  end
end
