class CreateAttachmentsWorksTable < ActiveRecord::Migration[5.2]
  def up
    create_join_table :attachments, :works
    Attachment.move_work_attaches_to_join_table
  end

  def down
    raise ActiveRecord::IrreversibleMigration.new("dataloss")
  end
end
