class AddLognotesToWorks < ActiveRecord::Migration
  def change
    add_column :works, :lognotes, :text
  end
end
