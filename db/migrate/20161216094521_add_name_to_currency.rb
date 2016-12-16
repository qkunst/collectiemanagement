class AddNameToCurrency < ActiveRecord::Migration[5.0]
  def change
    add_column :currencies, :name, :string
    Currency.all.each do |c|
      c.save!
    end
  end
end
