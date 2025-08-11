class LogisticalPeculiarities < ActiveRecord::Migration[7.2]
  def change
    create_table "logistical_peculiarities", force: :cascade do |t|
      t.string "name"
      t.boolean "hide", default: false
      t.datetime "created_at", precision: nil, null: false
      t.datetime "updated_at", precision: nil, null: false
    end
    create_join_table :logistical_peculiarities, :works
  end
end
