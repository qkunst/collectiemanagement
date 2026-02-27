# frozen_string_literal: true

class MakeSureSenderNameIsSet < ActiveRecord::Migration[5.2]
  def change
    Message.where(from_user_name: [nil, ""]).find_each { |a| a.save }
  end
end
