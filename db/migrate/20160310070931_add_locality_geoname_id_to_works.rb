# frozen_string_literal: true

class AddLocalityGeonameIdToWorks < ActiveRecord::Migration[4.2]
  def change
    add_column :works, :locality_geoname_id, :integer
  end
end
