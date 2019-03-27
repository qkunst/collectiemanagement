# frozen_string_literal: true

class AddMigrationAddReminderIdToMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :reminder_id, :integer
  end
end
