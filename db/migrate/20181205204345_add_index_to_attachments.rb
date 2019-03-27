# frozen_string_literal: true

class AddIndexToAttachments < ActiveRecord::Migration[5.2]
  def change
    add_index :attachments, [:attache_id, :attache_type]
  end
end
