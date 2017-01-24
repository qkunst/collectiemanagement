class ChangeNameLocalityToPlaceInvolvents < ActiveRecord::Migration[5.0]
  def change
    rename_column :involvements, :locality_geoname_id, :place_geoname_id
    rename_column :involvements, :city, :place
    remove_column :involvements, :country, :string
  end
end