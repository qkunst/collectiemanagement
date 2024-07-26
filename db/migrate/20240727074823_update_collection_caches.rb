class UpdateCollectionCaches < ActiveRecord::Migration[7.1]
  def change
    Work.reset_column_information # seeing errors related to removed columns

    Collection.all.each do |collection|
      collection.cache_work_attributes_present!
      collection.cache_derived_work_attributes_present!
    end
  end
end
