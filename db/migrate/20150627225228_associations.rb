# frozen_string_literal: true

class Associations < ActiveRecord::Migration[4.2]
  def change
    create_table :frame_damage_types_works, :force => true do |t|
      t.integer :frame_damage_type_id
      t.integer :work_id
    end
    create_table :damage_types_works, :force => true do |t|
      t.integer :damage_type_id
      t.integer :work_id
    end
    create_table :themes_works, :force => true do |t|
      t.integer :theme_id
      t.integer :work_id
    end
    create_table :techniques_works, :force => true do |t|
      t.integer :technique_id
      t.integer :work_id
    end
    create_table :object_categories_works, :force => true do |t|
      t.integer :object_category_id
      t.integer :work_id
    end
    create_table :artists_works, :force => true do |t|
      t.integer :artist_id
      t.integer :work_id
    end

  end
end
