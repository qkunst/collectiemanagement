class CreateArtistInvolvements < ActiveRecord::Migration
  def change
    create_table :artist_involvements do |t|
      t.integer :involvement_id
      t.integer :artist_id
      t.integer :start_year
      t.integer :end_year

      t.timestamps null: false
    end
  end
end
