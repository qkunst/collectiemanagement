class RootCollection < ActiveRecord::Migration[5.2]
  def self.up
    enable_extension "tablefunc" #    CREATE EXTENSION IF NOT EXISTS tablefunc;

    add_column :collections, :root, :boolean, default: false

    c = Collection.create(root: true, name: "-")

    change_column_default :collections, :parent_collection_id, c.id

    Collection.where(parent_collection_id: nil).where.not(root: true).update_all(parent_collection_id: c.id)
  end

  def self.down
    Collection.where(root: true).each do |c|
      c.collections.each do |sc|
        sc.parent_collection = nil
        sc.save
      end
    end

    change_column_default :collections, :parent_collection_id, nil

    Collection.where(root: true).destroy_all

    remove_column :collections, :root
  end
end