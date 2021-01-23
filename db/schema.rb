# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_01_23_141438) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "tablefunc"

  create_table "appraisals", id: :serial, force: :cascade do |t|
    t.date "appraised_on"
    t.decimal "market_value", precision: 16, scale: 2
    t.decimal "replacement_value", precision: 16, scale: 2
    t.string "appraised_by"
    t.integer "user_id"
    t.text "reference"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "appraisee_id"
    t.decimal "market_value_min", precision: 16, scale: 2
    t.decimal "market_value_max", precision: 16, scale: 2
    t.decimal "replacement_value_min", precision: 16, scale: 2
    t.decimal "replacement_value_max", precision: 16, scale: 2
    t.string "appraisee_type", default: "Work"
    t.text "notice"
    t.index ["appraisee_id"], name: "index_appraisals_on_appraisee_id"
  end

  create_table "artist_involvements", id: :serial, force: :cascade do |t|
    t.integer "involvement_id"
    t.integer "artist_id"
    t.integer "start_year"
    t.integer "end_year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "involvement_type"
    t.string "place"
    t.integer "place_geoname_id"
  end

  create_table "artists", id: :serial, force: :cascade do |t|
    t.string "place_of_birth"
    t.string "place_of_death"
    t.integer "year_of_birth"
    t.integer "year_of_death"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "prefix"
    t.string "last_name"
    t.integer "import_collection_id"
    t.integer "rkd_artist_id"
    t.integer "place_of_death_geoname_id"
    t.integer "place_of_birth_geoname_id"
    t.date "date_of_birth"
    t.date "date_of_death"
    t.text "geoname_ids_cache"
    t.string "artist_name"
    t.integer "replaced_by_artist_id"
    t.text "other_structured_data"
  end

  create_table "artists_attachments", id: false, force: :cascade do |t|
    t.bigint "attachment_id", null: false
    t.bigint "artist_id", null: false
  end

  create_table "artists_library_items", id: false, force: :cascade do |t|
    t.bigint "library_item_id", null: false
    t.bigint "artist_id", null: false
  end

  create_table "artists_works", id: :serial, force: :cascade do |t|
    t.integer "artist_id"
    t.integer "work_id"
    t.index ["artist_id"], name: "index_artists_works_on_artist_id"
    t.index ["work_id"], name: "index_artists_works_on_work_id"
  end

  create_table "attachments", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "attache_id"
    t.string "attache_type"
    t.string "file"
    t.string "visibility"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attache_id", "attache_type"], name: "index_attachments_on_attache_id_and_attache_type"
    t.index ["attache_id"], name: "index_attachments_on_attache_id"
  end

  create_table "attachments_works", id: false, force: :cascade do |t|
    t.bigint "attachment_id", null: false
    t.bigint "work_id", null: false
  end

  create_table "balance_categories", force: :cascade do |t|
    t.string "name"
    t.boolean "hide"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "batch_photo_uploads", id: :serial, force: :cascade do |t|
    t.string "zip_file"
    t.json "images"
    t.integer "collection_id"
    t.text "settings"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "finished_uploading", default: false
  end

  create_table "cached_apis", id: :serial, force: :cascade do |t|
    t.string "query"
    t.text "response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clusters", id: :serial, force: :cascade do |t|
    t.integer "collection_id"
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "collection_attributes", force: :cascade do |t|
    t.string "value_ciphertext"
    t.integer "collection_id"
    t.string "attributed_type"
    t.string "attributed_id"
    t.string "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "collections", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "exposable_fields"
    t.text "description"
    t.integer "parent_collection_id", default: 9
    t.string "label_override_work_alt_number_1"
    t.string "label_override_work_alt_number_2"
    t.string "label_override_work_alt_number_3"
    t.text "internal_comments"
    t.string "external_reference_code"
    t.text "geoname_ids_cache"
    t.text "collection_name_extended_cache"
    t.string "sort_works_by"
    t.boolean "base"
    t.boolean "root", default: false
    t.boolean "appraise_with_ranges"
    t.boolean "qkunst_managed", default: true
  end

  create_table "collections_geoname_summaries", id: :serial, force: :cascade do |t|
    t.integer "collection_id"
    t.integer "geoname_id"
  end

  create_table "collections_stages", id: :serial, force: :cascade do |t|
    t.integer "collection_id"
    t.integer "stage_id"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "collections_users", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "collection_id"
  end

  create_table "conditions", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order"
    t.boolean "hide", default: false
  end

  create_table "currencies", id: :serial, force: :cascade do |t|
    t.string "iso_4217_code"
    t.string "symbol"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.decimal "exchange_rate", precision: 16, scale: 8
    t.boolean "hide", default: false
  end

  create_table "custom_report_templates", force: :cascade do |t|
    t.string "title"
    t.text "text"
    t.integer "collection_id"
    t.text "work_fields"
    t.boolean "hide"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "custom_reports", force: :cascade do |t|
    t.integer "custom_report_template_id"
    t.string "title"
    t.string "variables"
    t.string "html_cache"
    t.integer "collection_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "custom_reports_works", id: false, force: :cascade do |t|
    t.bigint "custom_report_id", null: false
    t.bigint "work_id", null: false
    t.index ["custom_report_id", "work_id"], name: "index_custom_reports_works_on_custom_report_id_and_work_id", unique: true
  end

  create_table "damage_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "hide", default: false
  end

  create_table "damage_types_works", id: :serial, force: :cascade do |t|
    t.integer "damage_type_id"
    t.integer "work_id"
    t.index ["work_id"], name: "index_damage_types_works_on_work_id"
  end

  create_table "delayed_jobs", id: :serial, force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "frame_damage_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "hide", default: false
  end

  create_table "frame_damage_types_works", id: :serial, force: :cascade do |t|
    t.integer "frame_damage_type_id"
    t.integer "work_id"
    t.index ["work_id"], name: "index_frame_damage_types_works_on_work_id"
  end

  create_table "frame_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.boolean "hide"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "geoname_summaries", id: :serial, force: :cascade do |t|
    t.integer "geoname_id"
    t.string "name"
    t.string "language"
    t.string "parent_description"
    t.string "type_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "geoname_ids"
    t.text "parent_geoname_ids_cache"
    t.index ["geoname_id", "language"], name: "index_geoname_summaries_on_geoname_id_and_language"
    t.index ["geoname_id"], name: "index_geoname_summaries_on_geoname_id"
  end

  create_table "geoname_translations", id: :serial, force: :cascade do |t|
    t.integer "translation_id"
    t.integer "geoname_id"
    t.string "language"
    t.string "label"
    t.integer "priority"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["geoname_id"], name: "index_geoname_translations_on_geoname_id"
  end

  create_table "geonames", id: :serial, force: :cascade do |t|
    t.integer "geonameid"
    t.string "name"
    t.string "asciiname"
    t.text "alternatenames"
    t.float "latitude"
    t.float "longitude"
    t.string "feature_class"
    t.string "feature_code"
    t.string "country_code"
    t.string "cc2"
    t.string "admin1_code"
    t.string "admin2_code"
    t.string "admin3_code"
    t.string "admin4_code"
    t.integer "population"
    t.integer "elevation"
    t.string "dem"
    t.string "timezone"
    t.string "modification_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "geonames_admindivs", id: :serial, force: :cascade do |t|
    t.string "admin_code"
    t.string "name"
    t.string "asciiname"
    t.integer "geonameid"
    t.integer "admin_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_code"], name: "index_geonames_admindivs_on_admin_code"
  end

  create_table "geonames_countries", id: :serial, force: :cascade do |t|
    t.string "iso"
    t.string "iso3"
    t.string "iso_num"
    t.string "fips"
    t.string "country_name"
    t.string "capital_name"
    t.integer "area"
    t.integer "population"
    t.string "continent"
    t.string "tld"
    t.string "currency_code"
    t.string "currency_name"
    t.string "phone"
    t.string "postal_code_format"
    t.string "postal_code_regex"
    t.string "languages"
    t.integer "geoname_id"
    t.string "neighbours"
    t.string "equivalent_fips_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "import_collections", id: :serial, force: :cascade do |t|
    t.integer "collection_id"
    t.string "file"
    t.text "settings"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "import_file_snippet"
  end

  create_table "involvements", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "place"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "place_geoname_id"
  end

  create_table "library_items", force: :cascade do |t|
    t.string "item_type"
    t.integer "collection_id"
    t.string "title"
    t.string "author"
    t.string "ean"
    t.string "stock_number"
    t.string "location"
    t.text "description"
    t.string "thumbnail"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "library_items_works", id: false, force: :cascade do |t|
    t.bigint "library_item_id", null: false
    t.bigint "work_id", null: false
  end

  create_table "media", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "hide", default: false
  end

  create_table "messages", id: :serial, force: :cascade do |t|
    t.integer "from_user_id"
    t.integer "to_user_id"
    t.integer "in_reply_to_message_id"
    t.boolean "qkunst_private"
    t.integer "conversation_start_message_id"
    t.string "subject"
    t.text "message"
    t.text "subject_url"
    t.boolean "just_a_note"
    t.string "image"
    t.datetime "actioned_upon_by_qkunst_admin_at"
    t.string "subject_object_type"
    t.integer "subject_object_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "reminder_id"
    t.string "from_user_name"
    t.string "attachment"
  end

  create_table "object_categories", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "hide", default: false
  end

  create_table "object_categories_works", id: :serial, force: :cascade do |t|
    t.integer "object_category_id"
    t.integer "work_id"
    t.index ["work_id"], name: "index_object_categories_works_on_work_id"
  end

  create_table "owners", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "hide", default: false
    t.integer "collection_id"
  end

  create_table "placeabilities", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "order"
    t.boolean "hide", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reminders", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "text"
    t.integer "stage_id"
    t.integer "interval_length"
    t.string "interval_unit"
    t.boolean "repeat"
    t.integer "collection_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rkd_artists", id: :serial, force: :cascade do |t|
    t.integer "rkd_id"
    t.string "name"
    t.string "api_response_source_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "api_response"
    t.index ["rkd_id"], name: "index_rkd_artists_on_rkd_id"
  end

  create_table "sources", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "hide", default: false
  end

  create_table "sources_works", id: :serial, force: :cascade do |t|
    t.integer "work_id"
    t.integer "source_id"
    t.index ["work_id"], name: "index_sources_works_on_work_id"
  end

  create_table "stages", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "actual_stage_id"
    t.integer "previous_stage_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "styles", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "hide", default: false
  end

  create_table "subsets", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "hide", default: false
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "techniques", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "hide", default: false
  end

  create_table "techniques_works", id: :serial, force: :cascade do |t|
    t.integer "technique_id"
    t.integer "work_id"
    t.index ["work_id"], name: "index_techniques_works_on_work_id"
  end

  create_table "themes", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "hide", default: false
    t.integer "collection_id"
  end

  create_table "themes_works", id: :serial, force: :cascade do |t|
    t.integer "theme_id"
    t.integer "work_id"
    t.index ["work_id"], name: "index_themes_works_on_work_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin"
    t.boolean "qkunst"
    t.text "filter_params"
    t.boolean "facility_manager"
    t.boolean "receive_mails", default: true
    t.string "api_key"
    t.boolean "appraiser"
    t.string "name"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.text "collection_accessibility_serialization"
    t.boolean "advisor"
    t.boolean "compliance"
    t.boolean "role_manager"
    t.boolean "super_admin", default: false
    t.string "oauth_subject"
    t.string "oauth_provider"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "domain"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "work_set_types", force: :cascade do |t|
    t.string "name"
    t.boolean "count_as_one"
    t.boolean "appraise_as_one"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "hide"
  end

  create_table "work_sets", force: :cascade do |t|
    t.integer "work_set_type_id"
    t.string "identification_number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "appraisal_notice"
  end

  create_table "work_sets_works", id: false, force: :cascade do |t|
    t.bigint "work_id", null: false
    t.bigint "work_set_id", null: false
  end

  create_table "work_statuses", force: :cascade do |t|
    t.string "name"
    t.boolean "hide", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "works", id: :serial, force: :cascade do |t|
    t.integer "collection_id"
    t.string "location"
    t.string "stock_number"
    t.string "alt_number_1"
    t.string "alt_number_2"
    t.string "alt_number_3"
    t.string "photo_front"
    t.string "photo_back"
    t.string "photo_detail_1"
    t.string "photo_detail_2"
    t.string "title"
    t.boolean "title_unknown"
    t.text "description"
    t.integer "object_creation_year"
    t.boolean "object_creation_year_unknown"
    t.integer "medium_id"
    t.text "signature_comments"
    t.boolean "no_signature_present"
    t.string "print"
    t.float "frame_height"
    t.float "frame_width"
    t.float "frame_depth"
    t.float "frame_diameter"
    t.float "height"
    t.float "width"
    t.float "depth"
    t.float "diameter"
    t.integer "condition_work_id"
    t.text "condition_work_comments"
    t.integer "condition_frame_id"
    t.text "condition_frame_comments"
    t.text "information_back"
    t.text "other_comments"
    t.integer "source_id"
    t.text "source_comments"
    t.integer "style_id"
    t.integer "subset_id"
    t.decimal "market_value", precision: 16, scale: 2
    t.decimal "replacement_value", precision: 16, scale: 2
    t.decimal "purchase_price", precision: 16, scale: 2
    t.text "price_reference"
    t.string "grade_within_collection"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "artist_unknown"
    t.string "entry_status"
    t.text "entry_status_description"
    t.integer "created_by_id"
    t.text "medium_comments"
    t.string "abstract_or_figurative"
    t.integer "placeability_id"
    t.integer "purchase_price_currency_id"
    t.string "location_detail"
    t.date "valuation_on"
    t.text "internal_comments"
    t.integer "cluster_id"
    t.text "lognotes"
    t.datetime "imported_at"
    t.integer "import_collection_id"
    t.integer "locality_geoname_id"
    t.boolean "external_inventory"
    t.text "public_description"
    t.string "location_floor"
    t.date "purchased_on"
    t.string "artist_name_rendered"
    t.boolean "main_collection"
    t.boolean "image_rights"
    t.boolean "publish"
    t.integer "purchase_year"
    t.integer "frame_type_id"
    t.integer "owner_id"
    t.string "created_by_name"
    t.text "tag_list_cache"
    t.text "collection_locality_artist_involvements_texts_cache"
    t.datetime "inventoried_at"
    t.datetime "refound_at"
    t.datetime "new_found_at"
    t.decimal "market_value_min", precision: 16, scale: 2
    t.decimal "market_value_max", precision: 16, scale: 2
    t.decimal "replacement_value_min", precision: 16, scale: 2
    t.decimal "replacement_value_max", precision: 16, scale: 2
    t.decimal "minimum_bid", precision: 16, scale: 2
    t.decimal "selling_price", precision: 16, scale: 2
    t.boolean "print_unknown"
    t.decimal "purchase_price_in_eur", precision: 16, scale: 2
    t.text "selling_price_minimum_bid_comments"
    t.integer "work_status_id"
    t.text "other_structured_data"
    t.integer "balance_category_id"
    t.boolean "permanently_fixed"
    t.text "appraisal_notice"
    t.index ["collection_id"], name: "index_works_on_collection_id"
  end

end
