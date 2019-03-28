# frozen_string_literal: true

class AddEntryStatusToWorks < ActiveRecord::Migration[4.2]
  def change
    add_column :works, :entry_status, :string
    add_column :works, :entry_status_description, :text
  end
end
