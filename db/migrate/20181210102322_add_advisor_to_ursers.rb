# frozen_string_literal: true

class AddAdvisorToUrsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :advisor, :boolean
  end
end
