# frozen_string_literal: true

class AddFromUserNameToMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :from_user_name, :string
  end
end
