class PlaceabiltiyNaarFotograafToTag < ActiveRecord::Migration[5.2]
  def self.up
    placeability = Placeability.where(name: "Naar fotograaf").first
    works = placeability.works.all
    works.each do |work|
      work.tag_list = work.tag_list + [placeability.name]
      work.placeability = nil
      work.save
    end
    placeability.hide = true
    placeability.save
  end

  def self.down
    placeability = Placeability.where(name: "Naar fotograaf").first
    placeability.hide = false
    placeability.save
    works = Work.tagged_with(placeability.name)
    works.each do |work|
      work.tag_list = work.tag_list - [placeability.name]
      work.placeability ||= placeability
      work.save
    end
  end
end
