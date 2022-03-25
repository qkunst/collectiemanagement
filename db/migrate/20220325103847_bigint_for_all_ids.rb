class BigintForAllIds < ActiveRecord::Migration[6.1]
  def change

    change_column :works, "id", :bigint
    change_column :works, "collection_id", :bigint
    change_column :works, "medium_id", :bigint
    change_column :works, "condition_work_id", :bigint
    change_column :works, "condition_frame_id", :bigint
    change_column :works, "source_id", :bigint
    change_column :works, "style_id", :bigint
    change_column :works, "subset_id", :bigint
    change_column :works, "created_by_id", :bigint
    change_column :works, "placeability_id", :bigint
    change_column :works, "purchase_price_currency_id", :bigint
    change_column :works, "cluster_id", :bigint
    change_column :works, "import_collection_id", :bigint
    change_column :works, "locality_geoname_id", :bigint
    change_column :works, "frame_type_id", :bigint
    change_column :works, "owner_id", :bigint
    change_column :works, "work_status_id", :bigint
    change_column :works, "balance_category_id", :bigint

    change_column :appraisals, :id, :bigint
    change_column :artist_involvements, :id, :bigint
    change_column :artists, :id, :bigint
    change_column :artists_works, :id, :bigint
    change_column :attachments, :id, :bigint
    change_column :balance_categories, :id, :bigint
    change_column :batch_photo_uploads, :id, :bigint
    change_column :cached_apis, :id, :bigint
    change_column :clusters, :id, :bigint
    change_column :collection_attributes, :id, :bigint
    change_column :collections, :id, :bigint
    change_column :collections_geoname_summaries, :id, :bigint
    change_column :collections_stages, :id, :bigint
    change_column :collections_users, :id, :bigint
    change_column :conditions, :id, :bigint
    change_column :contacts, :id, :bigint
    change_column :currencies, :id, :bigint
    change_column :custom_report_templates, :id, :bigint
    change_column :custom_reports, :id, :bigint
    change_column :damage_types, :id, :bigint
    change_column :damage_types_works, :id, :bigint
    change_column :delayed_jobs, :id, :bigint
    change_column :frame_damage_types, :id, :bigint
    change_column :frame_damage_types_works, :id, :bigint
    change_column :frame_types, :id, :bigint
    change_column :geoname_summaries, :id, :bigint
    change_column :geoname_translations, :id, :bigint
    change_column :geonames, :id, :bigint
    change_column :geonames_admindivs, :id, :bigint
    change_column :geonames_countries, :id, :bigint
    change_column :import_collections, :id, :bigint
    change_column :involvements, :id, :bigint
    change_column :library_items, :id, :bigint
    change_column :media, :id, :bigint
    change_column :messages, :id, :bigint
    change_column :o_auth_group_mappings, :id, :bigint
    change_column :object_categories, :id, :bigint
    change_column :object_categories_works, :id, :bigint
    change_column :owners, :id, :bigint
    change_column :placeabilities, :id, :bigint
    change_column :reminders, :id, :bigint
    change_column :rkd_artists, :id, :bigint
    change_column :sources, :id, :bigint
    change_column :sources_works, :id, :bigint
    change_column :stages, :id, :bigint
    change_column :styles, :id, :bigint
    change_column :subsets, :id, :bigint
    change_column :taggings, :id, :bigint
    change_column :tags, :id, :bigint
    change_column :techniques, :id, :bigint
    change_column :techniques_works, :id, :bigint
    change_column :themes, :id, :bigint
    change_column :themes_works, :id, :bigint
    change_column :time_spans, :id, :bigint
    change_column :users, :id, :bigint
    change_column :versions, :id, :bigint
    change_column :work_set_types, :id, :bigint
    change_column :work_sets, :id, :bigint
    change_column :work_statuses, :id, :bigint
    change_column :works, :id, :bigint

    {
      appraisals: %w[user_id appraisee_id],
      artist_involvements: %w[involvement_id artist_id place_geoname_id ],
      artists: %w[import_collection_id rkd_artist_id place_of_death_geoname_id place_of_birth_geoname_id replaced_by_artist_id ],
      artists_works: %w[artist_id work_id],
      attachments: [:collection_id],
      batch_photo_uploads: %w[ collection_id ],
      clusters: %w[ collection_id ],
      collection_attributes: %w[ collection_id ],
      collections: %w[ parent_collection_id ],
      collections_geoname_summaries: %w[ collection_id geoname_id ],
      collections_stages: %w[ collection_id stage_id ],
      collections_users: %w[ user_id collection_id ],
      contacts: %w[ collection_id ],
      custom_report_templates: %w[ collection_id ],
      custom_reports: %w[ custom_report_template_id collection_id ],
      damage_types_works: %w[ damage_type_id work_id ],
      frame_damage_types_works: %w[ work_id frame_damage_type_id ],
      geoname_summaries: %w[ geoname_id ],
      geoname_translations: %w[ translation_id geoname_id ],
      geonames: %w[ geonameid ],
      geonames_admindivs: %w[ geonameid ],
      geonames_countries: %w[ geoname_id ],
      import_collections: %w[ collection_id],
      involvements: %w[ place_geoname_id  ],
      library_items: %w[ collection_id ],
      messages: %w[ from_user_id to_user_id in_reply_to_message_id conversation_start_message_id subject_object_id reminder_id ],
      object_categories_works: %w[ object_category_id work_id ],
      owners: %w[ collection_id ],
      reminders: %w[ stage_id collection_id ],
      rkd_artists: %w[ rkd_id ],
      sources_works: %w[ work_id source_id ],
      stages: %w[ actual_stage_id previous_stage_id ],
      taggings: %w[ tag_id taggable_id tagger_id ],
      techniques_works: %w[ technique_id work_id ],
      themes: %w[ collection_id ],
      themes_works: %w[ theme_id work_id ],
      time_spans: %w[ contact_id subject_id collection_id ],
      versions: %w[ item_id ],
      work_sets: %w[ work_set_type_id ]
    }.each do |table, fields|
      fields.each do |field|
        change_column table, field, :bigint
      end
    end
  end

end