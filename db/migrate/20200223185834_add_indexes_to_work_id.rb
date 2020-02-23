class AddIndexesToWorkId < ActiveRecord::Migration[5.2]
  def change
    add_index :artists_works, :work_id
    add_index :techniques_works, :work_id
    add_index :object_categories_works, :work_id
    add_index :damage_types_works, :work_id
    add_index :frame_damage_types_works, :work_id
    add_index :themes_works, :work_id
    add_index :sources_works, :work_id
    add_index :appraisals, :work_id
  end
end