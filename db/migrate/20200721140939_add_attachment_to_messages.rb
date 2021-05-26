# frozen_string_literal: true

class AddAttachmentToMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :attachment, :string
  end
end
