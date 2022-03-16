class AddHighlightAtToWorks < ActiveRecord::Migration[6.1]
  def change
    add_column :works, :highlight_at, :string
  end
end
