class ChangePolymorphicAssociationToRegularInAttachments < ActiveRecord::Migration[6.1]
  def self.up
    add_column :attachments, :collection_id, :integer
    Attachment.unscoped.where(attache_type: "Collection").each do |a|
      a.update_columns(collection_id: a.attache_id)
    end
    remove_column :attachments, :attache_type
    remove_column :attachments, :attache_id
  end
  def self.down
    add_column :attachments, :attache_type, :string
    add_column :attachments, :attache_id, :integer

    Attachment.unscoped.each do |a|
      a.update_columns(attache_id: a.collection_id, attache_type: "Collection")
    end

    remove_column :attachments, :collection_id, :integer
  end
end