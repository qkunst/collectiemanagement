# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170609150354) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "appraisals", force: :cascade do |t|
    t.date     "appraised_on"
    t.float    "market_value"
    t.float    "replacement_value"
    t.string   "appraised_by"
    t.integer  "user_id"
    t.text     "reference"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "work_id"
  end

  create_table "artist_involvements", force: :cascade do |t|
    t.integer  "involvement_id"
    t.integer  "artist_id"
    t.integer  "start_year"
    t.integer  "end_year"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "involvement_type"
    t.string   "place"
    t.integer  "place_geoname_id"
  end

  create_table "artists", force: :cascade do |t|
    t.string   "place_of_birth"
    t.string   "place_of_death"
    t.integer  "year_of_birth"
    t.integer  "year_of_death"
    t.text     "description"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "first_name"
    t.string   "prefix"
    t.string   "last_name"
    t.integer  "import_collection_id"
    t.integer  "rkd_artist_id"
    t.integer  "place_of_death_geoname_id"
    t.integer  "place_of_birth_geoname_id"
  end

  create_table "artists_works", force: :cascade do |t|
    t.integer "artist_id"
    t.integer "work_id"
    t.index ["work_id"], name: "index_artists_works_on_work_id", using: :btree
  end

  create_table "attachments", force: :cascade do |t|
    t.string   "name"
    t.integer  "attache_id"
    t.string   "attache_type"
    t.string   "file"
    t.string   "visibility"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["attache_id"], name: "index_attachments_on_attache_id", using: :btree
  end

  create_table "batch_photo_uploads", force: :cascade do |t|
    t.string   "zip_file"
    t.json     "images"
    t.integer  "collection_id"
    t.text     "settings"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "finished_uploading", default: false
  end

  create_table "cached_apis", force: :cascade do |t|
    t.string   "query"
    t.text     "response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clusters", force: :cascade do |t|
    t.integer  "collection_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "collections", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.text     "exposable_fields"
    t.text     "description"
    t.integer  "parent_collection_id"
    t.string   "label_override_work_alt_number_1"
    t.string   "label_override_work_alt_number_2"
    t.string   "label_override_work_alt_number_3"
    t.text     "internal_comments"
    t.string   "external_reference_code"
  end

  create_table "collections_geoname_summaries", force: :cascade do |t|
    t.integer "collection_id"
    t.integer "geoname_id"
  end

  create_table "collections_stages", force: :cascade do |t|
    t.integer  "collection_id"
    t.integer  "stage_id"
    t.datetime "completed_at"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "collections_users", force: :cascade do |t|
    t.integer "user_id"
    t.integer "collection_id"
  end

  create_table "conditions", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "order"
    t.boolean  "hide",       default: false
  end

  create_table "currencies", force: :cascade do |t|
    t.string   "iso_4217_code"
    t.string   "symbol"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "name"
  end

  create_table "damage_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "hide",       default: false
  end

  create_table "damage_types_works", force: :cascade do |t|
    t.integer "damage_type_id"
    t.integer "work_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "frame_damage_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "hide",       default: false
  end

  create_table "frame_damage_types_works", force: :cascade do |t|
    t.integer "frame_damage_type_id"
    t.integer "work_id"
  end

  create_table "frame_types", force: :cascade do |t|
    t.string   "name"
    t.boolean  "hide"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "geoname_summaries", force: :cascade do |t|
    t.integer  "geoname_id"
    t.string   "name"
    t.string   "language"
    t.string   "parent_description"
    t.string   "type_code"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "geoname_ids"
    t.index ["geoname_id", "language"], name: "index_geoname_summaries_on_geoname_id_and_language", using: :btree
    t.index ["geoname_id"], name: "index_geoname_summaries_on_geoname_id", using: :btree
  end

  create_table "geoname_translations", force: :cascade do |t|
    t.integer  "translation_id"
    t.integer  "geoname_id"
    t.string   "language"
    t.string   "label"
    t.integer  "priority"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["geoname_id"], name: "index_geoname_translations_on_geoname_id", using: :btree
  end

  create_table "geonames", force: :cascade do |t|
    t.integer  "geonameid"
    t.string   "name"
    t.string   "asciiname"
    t.text     "alternatenames"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "feature_class"
    t.string   "feature_code"
    t.string   "country_code"
    t.string   "cc2"
    t.string   "admin1_code"
    t.string   "admin2_code"
    t.string   "admin3_code"
    t.string   "admin4_code"
    t.integer  "population"
    t.integer  "elevation"
    t.string   "dem"
    t.string   "timezone"
    t.string   "modification_date"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "geonames_admindivs", force: :cascade do |t|
    t.string   "admin_code"
    t.string   "name"
    t.string   "asciiname"
    t.integer  "geonameid"
    t.integer  "admin_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_code"], name: "index_geonames_admindivs_on_admin_code", using: :btree
  end

  create_table "geonames_countries", force: :cascade do |t|
    t.string   "iso"
    t.string   "iso3"
    t.string   "iso_num"
    t.string   "fips"
    t.string   "country_name"
    t.string   "capital_name"
    t.integer  "area"
    t.integer  "population"
    t.string   "continent"
    t.string   "tld"
    t.string   "currency_code"
    t.string   "currency_name"
    t.string   "phone"
    t.string   "postal_code_format"
    t.string   "postal_code_regex"
    t.string   "languages"
    t.integer  "geoname_id"
    t.string   "neighbours"
    t.string   "equivalent_fips_code"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "import_collections", force: :cascade do |t|
    t.integer  "collection_id"
    t.string   "file"
    t.text     "settings"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.text     "import_file_snippet"
  end

  create_table "involvements", force: :cascade do |t|
    t.string   "name"
    t.string   "place"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "place_geoname_id"
  end

  create_table "media", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "hide",       default: false
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "from_user_id"
    t.integer  "to_user_id"
    t.integer  "in_reply_to_message_id"
    t.boolean  "qkunst_private"
    t.integer  "conversation_start_message_id"
    t.string   "subject"
    t.text     "message"
    t.text     "subject_url"
    t.boolean  "just_a_note"
    t.string   "image"
    t.datetime "actioned_upon_by_qkunst_admin_at"
    t.string   "subject_object_type"
    t.integer  "subject_object_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "reminder_id"
    t.string   "from_user_name"
  end

  create_table "object_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "hide",       default: false
  end

  create_table "object_categories_works", force: :cascade do |t|
    t.integer "object_category_id"
    t.integer "work_id"
  end

  create_table "placeabilities", force: :cascade do |t|
    t.string   "name"
    t.integer  "order"
    t.boolean  "hide",       default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "reminders", force: :cascade do |t|
    t.string   "name"
    t.text     "text"
    t.integer  "stage_id"
    t.integer  "interval_length"
    t.string   "interval_unit"
    t.boolean  "repeat"
    t.integer  "collection_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "rkd_artists", force: :cascade do |t|
    t.integer  "rkd_id"
    t.string   "name"
    t.string   "api_response_source_url"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.json     "api_response"
    t.index ["rkd_id"], name: "index_rkd_artists_on_rkd_id", using: :btree
  end

  create_table "sources", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "hide",       default: false
  end

  create_table "sources_works", force: :cascade do |t|
    t.integer "work_id"
    t.integer "source_id"
  end

  create_table "stages", force: :cascade do |t|
    t.string   "name"
    t.integer  "actual_stage_id"
    t.integer  "previous_stage_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "styles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "hide",       default: false
  end

  create_table "subsets", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "hide",       default: false
  end

  create_table "techniques", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "hide",       default: false
  end

  create_table "techniques_works", force: :cascade do |t|
    t.integer "technique_id"
    t.integer "work_id"
  end

  create_table "themes", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "hide",          default: false
    t.integer  "collection_id"
  end

  create_table "themes_works", force: :cascade do |t|
    t.integer "theme_id"
    t.integer "work_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",   null: false
    t.string   "encrypted_password",     default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.boolean  "admin"
    t.boolean  "qkunst"
    t.text     "filter_params"
    t.boolean  "facility_manager"
    t.boolean  "receive_mails",          default: true
    t.string   "api_key"
    t.boolean  "appraiser"
    t.string   "name"
    t.integer  "failed_attempts",        default: 0,    null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  end

  create_table "works", force: :cascade do |t|
    t.integer  "collection_id"
    t.string   "location"
    t.string   "stock_number"
    t.string   "alt_number_1"
    t.string   "alt_number_2"
    t.string   "alt_number_3"
    t.string   "photo_front"
    t.string   "photo_back"
    t.string   "photo_detail_1"
    t.string   "photo_detail_2"
    t.string   "title"
    t.boolean  "title_unknown"
    t.text     "description"
    t.integer  "object_creation_year"
    t.boolean  "object_creation_year_unknown"
    t.integer  "medium_id"
    t.text     "signature_comments"
    t.boolean  "no_signature_present"
    t.string   "print"
    t.float    "frame_height"
    t.float    "frame_width"
    t.float    "frame_depth"
    t.float    "frame_diameter"
    t.float    "height"
    t.float    "width"
    t.float    "depth"
    t.float    "diameter"
    t.integer  "condition_work_id"
    t.text     "condition_work_comments"
    t.integer  "condition_frame_id"
    t.text     "condition_frame_comments"
    t.text     "information_back"
    t.text     "other_comments"
    t.integer  "source_id"
    t.text     "source_comments"
    t.integer  "style_id"
    t.integer  "subset_id"
    t.float    "market_value"
    t.float    "replacement_value"
    t.float    "purchase_price"
    t.text     "price_reference"
    t.string   "grade_within_collection"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "artist_unknown"
    t.string   "entry_status"
    t.text     "entry_status_description"
    t.integer  "created_by_id"
    t.text     "medium_comments"
    t.string   "abstract_or_figurative"
    t.integer  "placeability_id"
    t.integer  "purchase_price_currency_id"
    t.string   "location_detail"
    t.date     "valuation_on"
    t.text     "internal_comments"
    t.integer  "cluster_id"
    t.text     "lognotes"
    t.datetime "imported_at"
    t.integer  "import_collection_id"
    t.integer  "locality_geoname_id"
    t.boolean  "external_inventory"
    t.text     "public_description"
    t.string   "location_floor"
    t.date     "purchased_on"
    t.string   "artist_name_rendered"
    t.boolean  "main_collection"
    t.boolean  "image_rights"
    t.boolean  "publish"
    t.integer  "purchase_year"
    t.integer  "frame_type_id"
  end

end
