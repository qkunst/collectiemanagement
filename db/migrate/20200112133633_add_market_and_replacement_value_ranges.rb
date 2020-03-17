class AddMarketAndReplacementValueRanges < ActiveRecord::Migration[5.2]
  def change
    add_column :collections, :appraise_with_ranges, :boolean, default: false
    add_column :appraisals, :market_value_min, :decimal, scale: 2, precision: 16
    add_column :appraisals, :market_value_max, :decimal, scale: 2, precision: 16
    add_column :appraisals, :replacement_value_min, :decimal, scale: 2, precision: 16
    add_column :appraisals, :replacement_value_max, :decimal, scale: 2, precision: 16
    add_column :works, :market_value_min, :decimal, scale: 2, precision: 16
    add_column :works, :market_value_max, :decimal, scale: 2, precision: 16
    add_column :works, :replacement_value_min, :decimal, scale: 2, precision: 16
    add_column :works, :replacement_value_max, :decimal, scale: 2, precision: 16
  end
end
