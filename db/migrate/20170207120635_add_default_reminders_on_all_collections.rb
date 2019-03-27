# frozen_string_literal: true

class AddDefaultRemindersOnAllCollections < ActiveRecord::Migration[5.0]
  def change
    Collection.all.each do |c|
      c.copy_default_reminders!
    end
  end
end
