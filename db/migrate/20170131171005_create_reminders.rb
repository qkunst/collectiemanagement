class CreateReminders < ActiveRecord::Migration[5.0]
  def change
    create_table :reminders do |t|
      t.string :name
      t.text :text
      t.integer :stage_id
      t.integer :interval_length
      t.string :interval_unit
      t.boolean :repeat
      t.integer :collection_id

      t.timestamps
    end
        #
    # Controle nodig (Iedere 1 jaar na oplevering)
    # Taxatie nodig (Iedere 3 jaar na oplevering)
    # Maar ook b.v. een Test herinnering (Iedere dag)
    Reminder.create(
      name: "Controle nodig",
      text: "Het is een jaar geleden sinds QKunst heeft gekeken naar deze collectie.",
      stage: Stage.where(name: "Oplevering").first,
      repeat: true,
      interval_length: 1,
      interval_unit: :years
    )
    Reminder.create(
      name: "Herziening waardering gewenst",
      text: "Het is een drie jaar geleden dat QKunst de waardering heeft verzorgd van de werken in deze collectie.",
      stage: Stage.where(name: "Waardering").first,
      repeat: true,
      interval_length: 3,
      interval_unit: :years
    )
  end
end
