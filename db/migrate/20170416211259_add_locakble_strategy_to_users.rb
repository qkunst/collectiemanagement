# frozen_string_literal: true

class AddLocakbleStrategyToUsers < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |t|
      t.integer :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      t.string :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at
    end
  end
end
