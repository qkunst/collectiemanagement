class FloatsToDecimalsAppraisalRelated < ActiveRecord::Migration[5.2]
  def change
    change_column :appraisals, :market_value, :decimal, scale: 2, precision: 16
    change_column :appraisals, :replacement_value, :decimal, scale: 2, precision: 16
    change_column :works, :market_value, :decimal, scale: 2, precision: 16
    change_column :works, :replacement_value, :decimal, scale: 2, precision: 16
    change_column :works, :purchase_price, :decimal, scale: 2, precision: 16
  end
end
