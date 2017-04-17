class AddPurchaseYearToWorks < ActiveRecord::Migration[5.0]
  def change
    add_column :works, :purchase_year, :integer
    Work.where.not(purchased_on: nil).each do |w|
      w.purchase_year = w.purchased_on.year
      w.save
    end
  end
end
