# when finished development, this may become static
json.extract! work, :title_rendered, :id, :artist_name_rendered, :collection_id, :stock_number, :selling_price

json.photo_front do |photo|
  json.thumb "#{request.base_url}#{work.photo_front.thumb.url}" if work.photo_front?
  json.big_thumb "#{request.base_url}#{work.photo_front.big_thumb.url}" if work.photo_front?
  json.screen "#{request.base_url}#{work.photo_front.screen.url}" if work.photo_front?
end

# json.available work.available? # work_limited.json is only included in time_spans for now; so perhaps not needed; relatively expensive call

json.url collection_work_url(work.collection_id, work.id)
