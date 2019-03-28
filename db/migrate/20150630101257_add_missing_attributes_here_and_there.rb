# frozen_string_literal: true

class AddMissingAttributesHereAndThere < ActiveRecord::Migration[4.2]
  def change
    add_column :conditions, :order, :integer
    add_column :conditions, :hide, :boolean, default: false
    add_column :themes, :hide, :boolean, default: false
    add_column :object_categories, :hide, :boolean, default: false
    add_column :techniques, :hide, :boolean, default: false
    add_column :media, :hide, :boolean, default: false
    add_column :damage_types, :hide, :boolean, default: false
    add_column :frame_damage_types, :hide, :boolean, default: false
    add_column :sources, :hide, :boolean, default: false
    add_column :styles, :hide, :boolean, default: false
    add_column :subsets, :hide, :boolean, default: false
    add_column :works, :medium_comments, :text
    add_column :works, :abstract_or_figurative, :string
  end
end
