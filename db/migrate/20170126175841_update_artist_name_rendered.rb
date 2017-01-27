class UpdateArtistNameRendered < ActiveRecord::Migration[5.0]
  def change
    Work.all.each do |work|
      work.save
    end
  end
end
