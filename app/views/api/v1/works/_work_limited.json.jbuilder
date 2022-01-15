# when finished development, this may become static
json.extract! work, :title_rendered, :id, :artist_name_rendered, :collection_id

json.photo_front do |photo|
  json.thumb "#{request.base_url}#{work.photo_front.thumb.url}" if work.photo_front?
  json.original "#{request.base_url}#{work.photo_front.url}" if work.photo_front?
  json.screen "#{request.base_url}#{work.photo_front.screen.url}" if work.photo_front?
end

json.available work.available?

json.url collection_work_url(work.collection, work)