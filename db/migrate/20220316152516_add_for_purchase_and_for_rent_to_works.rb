class AddForPurchaseAndForRentToWorks < ActiveRecord::Migration[6.1]
  def change
    add_column :works, :for_purchase_at, :datetime
    add_column :works, :for_rent_at, :datetime
  end
end
