# frozen_string_literal: true

database_fields = current_api_user.ability.viewable_work_fields.select{|a| [String, Symbol].include?(a.class)} - [:style, :medium, :subset, :condition_work, :condition_work_id, :condition_frame, :condition_frame_id, :work_status_id, :work_status, :artist_ids, :damage_type_ids, :frame_damage_type_ids]

work = @work

# when finished development, this may become static
json.extract! work, *database_fields

json.sources(work.sources) { |attribute| json.extract! attribute, :name, :id } if current_api_user.ability.viewable_work_fields.include?(:sources)
json.artists(work.artists) { |attribute| json.extract! attribute, :name, :id, :first_name, :prefix, :last_name, :year_of_birth, :year_of_death } if current_api_user.ability.viewable_work_fields.include?(:artists)
json.object_categories(work.object_categories) { |attribute| json.extract! attribute, :name, :id } if current_api_user.ability.viewable_work_fields.include?(:object_categories)
json.techniques(work.techniques) { |attribute| json.extract! attribute, :name, :id } if current_api_user.ability.viewable_work_fields.include?(:techniques)
json.damage_types(work.damage_types) { |attribute| json.extract! attribute, :name, :id } if current_api_user.ability.viewable_work_fields.include?(:damage_types)
json.frame_damage_types(work.frame_damage_types) { |attribute| json.extract! attribute, :name, :id } if current_api_user.ability.viewable_work_fields.include?(:frame_damage_types)
json.themes(work.themes) { |attribute| json.extract! attribute, :name, :id } if current_api_user.ability.viewable_work_fields.include?(:themes)

json.style { json.extract! work.style, :name, :id } if work.style && current_api_user.ability.viewable_work_fields.include?(:style)
json.cluster { json.extract! work.cluster, :name, :id } if work.cluster && current_api_user.ability.viewable_work_fields.include?(:cluster)
json.medium { json.extract! work.medium, :name, :id } if work.medium && current_api_user.ability.viewable_work_fields.include?(:medium)
json.condition_work { json.extract! work.condition_work, :name, :id } if work.condition_work && current_api_user.ability.viewable_work_fields.include?(:condition_work)
json.condition_frame { json.extract! work.condition_frame, :name, :id } if work.condition_frame && current_api_user.ability.viewable_work_fields.include?(:condition_frame)
json.subset { json.extract! work.subset, :name, :id } if work.subset && current_api_user.ability.viewable_work_fields.include?(:subset)
json.placeability { json.extract! work.placeability, :name, :id } if work.placeability && current_api_user.ability.viewable_work_fields.include?(:placeability)
json.work_status { json.extract! work.work_status, :name, :id } if work.work_status && current_api_user.ability.viewable_work_fields.include?(:work_status)

json.artist_name_rendered work.artist_name_rendered
json.artist_name_rendered_without_years_nor_locality work.artist_name_rendered_without_years_nor_locality
json.frame_size work.frame_size
json.work_size work.work_size
json.object_format_code work.object_format_code

json.url collection_work_url(work.collection, work)