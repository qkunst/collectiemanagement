# frozen_string_literal: true

class RootCollection < ActiveRecord::Migration[5.2]
  def self.up
    enable_extension "tablefunc" #    CREATE EXTENSION IF NOT EXISTS tablefunc;

    add_column :collections, :root, :boolean, default: false

    Collection.unscoped.insert(root: true, name: "-", created_at: Time.now, updated_at: Time.now)

    c = Collection.unscoped.where(root: true).first
    change_column_default :collections, :parent_collection_id, c.id

    Collection.unscoped.where(parent_collection_id: nil).where.not(root: true).update_all(parent_collection_id: c.id)
  end

  def self.down
    Collection.where(root: true).each do |c|
      c.collections.each do |sc|
        sc.parent_collection = nil
        sc.save
      end
    end

    change_column_default :collections, :parent_collection_id, nil

    Collection.unscoped.where(root: true).destroy_all

    remove_column :collections, :root
  end
end
