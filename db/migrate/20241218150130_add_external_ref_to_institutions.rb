class AddExternalRefToInstitutions < ActiveRecord::Migration[7.2]
  def change
    add_column :involvements, :external_reference, :string
  end
end
