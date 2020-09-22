class ArtistsAttachmentRelation < ActiveRecord::Migration[5.2]
  def change
    create_table "artists_attachments", id: false, force: :cascade do |t|
      t.bigint "attachment_id", null: false
      t.bigint "artist_id", null: false
    end
  end
end
