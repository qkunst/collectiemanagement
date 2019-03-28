# frozen_string_literal: true

class AddReceiveMailsToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :receive_mails, :boolean, default: true
  end
end
