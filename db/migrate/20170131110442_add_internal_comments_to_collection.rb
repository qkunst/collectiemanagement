class AddInternalCommentsToCollection < ActiveRecord::Migration[5.0]
  def change
    add_column :collections, :internal_comments, :text
  end
end
