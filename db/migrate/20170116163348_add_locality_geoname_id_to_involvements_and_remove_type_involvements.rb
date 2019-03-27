# frozen_string_literal: true

class AddLocalityGeonameIdToInvolvementsAndRemoveTypeInvolvements < ActiveRecord::Migration[5.0]
  def change
    add_column :involvements, :locality_geoname_id, :integer
    remove_column :involvements, :type, :string
    add_column :artist_involvements, :involvement_type, :string
  end
end
