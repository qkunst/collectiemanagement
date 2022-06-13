# when finished development, this may become static
json.extract! work, *exposable_database_fields

json.photo_front do |photo|
  json.thumb "#{request.base_url}#{work.photo_front.thumb.url}" if work.photo_front?
  json.big_thumb "#{request.base_url}#{work.photo_front.big_thumb.url}" if work.photo_front?
  json.original "#{request.base_url}#{work.photo_front.url}" if work.photo_front?
  json.screen "#{request.base_url}#{work.photo_front.screen.url}" if work.photo_front?
end
json.photo_back do |photo|
  json.thumb "#{request.base_url}#{work.photo_back.thumb.url}" if work.photo_back?
  json.original "#{request.base_url}#{work.photo_back.url}" if work.photo_back?
  json.screen "#{request.base_url}#{work.photo_back.screen.url}" if work.photo_back?
end
json.photo_detail_1 do |photo|
  json.thumb "#{request.base_url}#{work.photo_detail_1.thumb.url}" if work.photo_detail_1?
  json.original "#{request.base_url}#{work.photo_detail_1.url}" if work.photo_detail_1?
  json.screen "#{request.base_url}#{work.photo_detail_1.screen.url}" if work.photo_detail_1?
end
json.photo_detail_2 do |photo|
  json.thumb "#{request.base_url}#{work.photo_detail_2.thumb.url}" if work.photo_detail_2?
  json.original "#{request.base_url}#{work.photo_detail_2.url}" if work.photo_detail_2?
  json.screen "#{request.base_url}#{work.photo_detail_2.screen.url}" if work.photo_detail_2?
end

json.sources(work.sources) { |attribute| json.extract! attribute, :name, :id } if current_api_user.ability.viewable_work_fields.include?(:sources)
json.artists(work.artists) { |attribute| json.extract! attribute, :name, :id, :first_name, :prefix, :last_name, :year_of_birth, :year_of_death, :rkd_artist_id, :artist_name } if current_api_user.ability.viewable_work_fields.include?(:artists)
json.object_categories(work.object_categories) { |attribute| json.extract! attribute, :name, :id } if current_api_user.ability.viewable_work_fields.include?(:object_categories)
json.techniques(work.techniques) { |attribute| json.extract! attribute, :name, :id } if current_api_user.ability.viewable_work_fields.include?(:techniques)
json.damage_types(work.damage_types) { |attribute| json.extract! attribute, :name, :id } if current_api_user.ability.viewable_work_fields.include?(:damage_types)
json.frame_damage_types(work.frame_damage_types) { |attribute| json.extract! attribute, :name, :id } if current_api_user.ability.viewable_work_fields.include?(:frame_damage_types)
json.themes(work.themes) { |attribute| json.extract! attribute, :name, :id } if current_api_user.ability.viewable_work_fields.include?(:themes)
json.purchase_price_currency_iso_4217_code work.purchase_price_currency&.iso_4217_code
json.style { json.extract! work.style, :name, :id } if work.style && current_api_user.ability.viewable_work_fields.include?(:style)
json.cluster { json.extract! work.cluster, :name, :id } if work.cluster && current_api_user.ability.viewable_work_fields.include?(:cluster)
json.medium { json.extract! work.medium, :name, :id } if work.medium && current_api_user.ability.viewable_work_fields.include?(:medium)
json.condition_work { json.extract! work.condition_work, :name, :id } if work.condition_work && current_api_user.ability.viewable_work_fields.include?(:condition_work)
json.condition_frame { json.extract! work.condition_frame, :name, :id } if work.condition_frame && current_api_user.ability.viewable_work_fields.include?(:condition_frame)
json.subset       { json.extract! work.subset, :name, :id }       if work.subset       && current_api_user.ability.viewable_work_fields.include?(:subset)
json.placeability { json.extract! work.placeability, :name, :id } if work.placeability && current_api_user.ability.viewable_work_fields.include?(:placeability)
json.work_status { json.extract! work.work_status, :name, :id } if work.work_status
json.owner { json.extract! work.owner, :name, :id, :creating_artist } if work.owner && current_api_user.ability.can?(:read, Owner)

if current_api_user.ability.can?(:read, Appraisal)
  json.appraisals(work.appraisals) do |appraisal|
    json.partial! 'api/v1/appraisals/appraisal', locals: {appraisal: appraisal}
  end
  json.balance_category { json.extract! work.balance_category, :name, :id } if work.balance_category

end
json.work_sets(work.work_sets) do |work_set|
  json.work_set_type { |work_set_type| json.extract! work_set_type, :name, :count_as_one, :appraise_as_one}
  json.identification_number work_set.identification_number

  json.appraisal_notice work_set.appraisal_notice   if current_api_user.ability.can?(:read, Appraisal)
  json.comment work_set.comment
end

json.collection_branch_names (@collection_branches ? @collection_branches[work.collection_id] : work.collection_branch.select(:name).map(&:name))

json.artist_name_rendered work.artist_name_rendered
json.artist_name_rendered_without_years_nor_locality work.artist_name_rendered_without_years_nor_locality
json.frame_size work.frame_size
json.work_size work.work_size
json.height_with_fallback work.height_with_fallback
json.width_with_fallback work.width_with_fallback
json.depth_with_fallback work.depth_with_fallback
json.diameter_with_fallback work.diameter_with_fallback
json.object_format_code work.object_format_code
json.orientation work.orientation
json.for_purchase work.for_purchase?
json.for_rent work.for_rent?
json.highlight work.highlight?
json.created_at work.created_at
json.import_collection_id work.import_collection_id
json.availability_status work.availability_status
if current_api_user.ability.can?(:read, TimeSpan)
  json.time_spans(work.time_spans) do |time_span|
    json.partial! 'api/v1/time_spans/time_span', locals: {time_span: time_span, work_context: true}
  end
  json.current_active_timespan do
    if work.current_active_time_span
      json.partial! 'api/v1/time_spans/time_span', locals: {time_span: work.current_active_time_span, work_context: true}
    end
  end
end
json.available work.available?
json.tag_list work.cached_tag_list

json.url collection_work_url(work.collection, work)