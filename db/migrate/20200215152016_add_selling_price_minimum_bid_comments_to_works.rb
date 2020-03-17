class AddSellingPriceMinimumBidCommentsToWorks < ActiveRecord::Migration[5.2]
  def change
    add_column :works, :selling_price_minimum_bid_comments, :text
  end
end
