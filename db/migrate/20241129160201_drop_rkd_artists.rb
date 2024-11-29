class DropRkdArtists < ActiveRecord::Migration[7.2]
  def change
    drop_table "rkd_artists", force: :cascade do |t|
      t.bigint "rkd_id"
      t.string "name"
      t.string "api_response_source_url"
      t.datetime "created_at", precision: nil, null: false
      t.datetime "updated_at", precision: nil, null: false
      t.json "api_response"
      t.index ["rkd_id"], name: "index_rkd_artists_on_rkd_id"
    end
  end
end
