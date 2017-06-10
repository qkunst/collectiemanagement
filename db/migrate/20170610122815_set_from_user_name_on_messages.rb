class SetFromUserNameOnMessages < ActiveRecord::Migration[5.0]
  def change
    Message.all.each do |a|
      a.set_from_user_name!
      a.save
    end
  end
end
