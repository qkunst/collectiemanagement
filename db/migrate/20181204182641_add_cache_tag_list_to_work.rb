# frozen_string_literal: true

class AddCacheTagListToWork < ActiveRecord::Migration[5.2]
  def change
    add_column :works, :tag_list_cache, :text
    Work.all.each { |c| c.cache_tag_list!(true) }
  end
end
