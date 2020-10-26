class AddQkunstManagedToCollection < ActiveRecord::Migration[5.2]
  def change
    add_column :collections, :qkunst_managed, :boolean, default: true
  end
end
