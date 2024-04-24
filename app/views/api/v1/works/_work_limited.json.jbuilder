# when finished development, this may become static
json.extract! work, :title_rendered, :id, :artist_name_rendered, :collection_id, :stock_number, :selling_price, :business_rent_price_ex_vat, :default_rent_price

json.photo_front do |photo|
  json.thumb "#{request.base_url}#{work.photo_front.thumb.url}" if work.photo_front?
  json.big_thumb "#{request.base_url}#{work.photo_front.big_thumb.url}" if work.photo_front?
  json.screen "#{request.base_url}#{work.photo_front.screen.url}" if work.photo_front?
end

# json.available work.available? # work_limited.json is only included in time_spans for now; so perhaps not needed; relatively expensive call

json.url collection_work_url(work.collection_id, work.id)

if defined?(current_active_time_span) && current_active_time_span && current_api_user.ability.can?(:read, TimeSpan)
  json.current_active_time_span do
    if work.current_active_time_span
      json.partial! "api/v1/time_spans/time_span", locals: {time_span: work.current_active_time_span, work_context: true}
    end
  end
end
