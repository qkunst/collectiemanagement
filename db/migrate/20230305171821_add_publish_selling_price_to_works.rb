class AddPublishSellingPriceToWorks < ActiveRecord::Migration[7.0]
  def change
    add_column :works, :publish_selling_price, :boolean, default: true
  end
end
