# frozen_string_literal: true

class AddLognotesToWorks < ActiveRecord::Migration[4.2]
  def change
    add_column :works, :lognotes, :text
  end
end
