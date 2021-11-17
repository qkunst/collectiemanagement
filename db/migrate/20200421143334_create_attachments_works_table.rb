# frozen_string_literal: true

class CreateAttachmentsWorksTable < ActiveRecord::Migration[5.2]
  def up
    create_join_table :attachments, :works
  end

  def down
    raise ActiveRecord::IrreversibleMigration.new("dataloss")
  end
end
