# frozen_string_literal: true

json.array!(@works) do |work|
  json.extract! work, :id, :collection_id, :created_by, :location, :stock_number, :alt_number_1, :alt_number_2, :alt_number_3, :photo_front, :photo_back, :photo_detail_1, :photo_detail_2, :artist_unknown, :title, :title_unknown, :description, :object_creation_year, :object_creation_year_unknown, :medium_id, :signature_comments, :no_signature_present, :print, :frame_height, :frame_width, :frame_depth, :frame_diameter, :height, :width, :depth, :diameter, :condition_work_id, :condition_work_comments, :condition_frame_id, :condition_frame_comments, :information_back, :other_comments, :source_id, :source_comments, :style_id, :subset_id, :market_value, :replacement_value, :purchase_price, :price_reference, :grade_within_collection, :artist_name_rendered
  json.artist_name_rendered_without_years_nor_locality work.artist_name_rendered_without_years_nor_locality
  json.url work_url(work, format: :json)
end
