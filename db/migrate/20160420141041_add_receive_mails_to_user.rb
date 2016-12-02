class AddReceiveMailsToUser < ActiveRecord::Migration
  def change
    add_column :users, :receive_mails, :boolean, default: true
  end
end
