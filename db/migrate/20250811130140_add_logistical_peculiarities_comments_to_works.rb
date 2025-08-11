class AddLogisticalPeculiaritiesCommentsToWorks < ActiveRecord::Migration[7.2]
  def change
    add_column :works, :logistical_peculiarities_comments, :text
  end
end
