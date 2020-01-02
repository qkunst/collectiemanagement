class MakeSureSenderNameIsSet < ActiveRecord::Migration[5.2]
  def change
    Message.where(from_user_name: [nil,""]).each{|a| a.save}
  end
end
