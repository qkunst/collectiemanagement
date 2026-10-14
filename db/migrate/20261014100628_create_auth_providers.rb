class CreateAuthProviders < ActiveRecord::Migration[8.1]
  def change
    create_table :auth_providers do |t|
      t.string :strategy
      t.string :client_id
      t.string :secret
      t.json :options

      t.timestamps
    end
  end
end
