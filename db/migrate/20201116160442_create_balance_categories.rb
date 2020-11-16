class CreateBalanceCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :balance_categories do |t|
      t.string :name
      t.boolean :hide

      t.timestamps
    end

    ["Geen kunst",
    "Te weinig informatie",
    "Organisatie- en/of cultuurhistorische waarde overstijgt marktwaarde",
    "Gewaardeerd als serie op één inv.nr. (Komt te vervallen na feature koppeling meerluiken)",
    "Andere expertise: Etnografica",
    "Andere expertise: Design, antiek, kunstnijverheid, curiosa",
    "Andere expertise: Cartografie en antieke prenten",
    "Andere expertise: Beeldende kunst van vóór 20e/21e-eeuw"].each do |name|
      BalanceCategory.create(name: name)
    end


  end
end
