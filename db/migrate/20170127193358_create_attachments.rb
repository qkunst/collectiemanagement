class CreateAttachments < ActiveRecord::Migration[5.0]
  def change
    create_table :attachments do |t|
      t.string :name
      t.references :attache
      t.string :attache_type
      t.string :file
      t.string :visibility

      t.timestamps
    end
  end
end
