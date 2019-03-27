# frozen_string_literal: true

class AddApiKeyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :api_key, :string
  end
end
