class CreateOrganisations < ActiveRecord::Migration[8.1]
  def change
    create_table :organisations do |t|
      t.json :domains
      t.references :auth_provider, null: true, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
