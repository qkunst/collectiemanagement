module ImportCollection::Json
  def write_json_work(work_data)
    as_is_fields = %w[stock_number alt_number_1 alt_number_2 alt_number_3 alt_number_4 alt_number_5 alt_number_6 title title_unknown description object_creation_year object_creation_year_unknown print print_unknown frame_height frame_width frame_depth frame_diameter height width depth diameter public_description abstract_or_figurative location_detail location location_floor internal_comments inventoried refound new_found inventoried_at refound_at new_found_at geoname_id artist_unknown signature_comments no_signature_present information_back other_comments grade_within_collection entry_status entry_status_description medium_comments main_collection image_rights publish permanently_fixed condition_work_comments condition_frame_comments source_comments purchase_price purchased_on purchase_year selling_price minimum_bid market_value_max market_value_min replacement_value_min replacement_value_max valuation_on market_value replacement_value for_purchase for_rent highlight for_purchase_at for_rent_at highlight_at work_data selling_price_minimum_bid_comments id tag_list significantly_updated_at created_at removed_from_collection_at removed_from_collection_note]

    work = Work.new(work_data.select { |k, v| as_is_fields.include? k })
    work.collection = collection
    work.import_collection_id = id

    # Photo's
    begin
      oringal_photo_front = work_data["photo_front"]&.[]("original")
      work.photo_front = URI.open(oringal_photo_front) if oringal_photo_front
    rescue TypeError
      begin
        oringal_photo_front = work_data["photo_front"]&.[]("screen")
        work.photo_front = URI.open(oringal_photo_front) if oringal_photo_front
      rescue TypeError
        puts "Image oringal_photo_front failed... ignoring."
      end
    end

    begin
      oringal_photo_back = work_data["photo_back"]&.[]("original")
      work.photo_back = URI.open(oringal_photo_back) if oringal_photo_back
    rescue TypeError
      begin
        oringal_photo_back = work_data["photo_back"]&.[]("screen")
        work.photo_back = URI.open(oringal_photo_back) if oringal_photo_back
      rescue TypeError
        puts "Image oringal_photo_back failed... ignoring."
      end
    end

    begin
      oringal_photo_detail_1 = work_data["photo_detail_1"]&.[]("original")
      work.photo_detail_1 = URI.open(oringal_photo_detail_1) if oringal_photo_detail_1
    rescue TypeError
      begin
        oringal_photo_detail_1 = work_data["photo_detail_1"]&.[]("screen")
        work.photo_detail_1 = URI.open(oringal_photo_detail_1) if oringal_photo_detail_1
      rescue TypeError
        puts "Image oringal_photo_detail_1 failed... ignoring."
      end
    end

    begin
      oringal_photo_detail_2 = work_data["photo_detail_2"]&.[]("original")
      work.photo_detail_2 = URI.open(oringal_photo_detail_2) if oringal_photo_detail_2
    rescue TypeError
      begin
        oringal_photo_detail_2 = work_data["photo_detail_2"]&.[]("screen")
        work.photo_detail_2 = URI.open(oringal_photo_detail_2) if oringal_photo_detail_2
      rescue TypeError
        puts "Image oringal_photo_detail_2 failed... ignoring."
      end
    end

    cluster_data = work_data["cluster"]
    if cluster_data
      work.cluster = (Cluster.where(name: cluster_data["name"], collection: base_collection.expand_with_child_collections).first || Cluster.create(name: cluster_data["name"], collection: collection.base_collection))
    end

    owner_data = work_data["owner"]
    if owner_data
      work.owner = (Owner.where(name: owner_data["name"], collection: base_collection.expand_with_child_collections).first || Owner.create(name: owner_data["name"], collection: collection.base_collection, creating_artist: owner_data["creating_artist"]))
    end

    purchase_price_currency = work_data["purchase_price_currency_iso_4217_code"]
    if purchase_price_currency
      work.purchase_price_currency = Currency.find_or_create_by(iso_4217_code: purchase_price_currency)
    end

    work_data["object_categories"]&.each do |object_category|
      work.object_categories << ObjectCategory.find_or_create_by(name: object_category["name"])
    end
    if work_data["placeability"]
      work.placeability = Placeability.find_or_create_by(name: work_data["placeability"]["name"])
    end
    if work_data["balance_category"]
      work.balance_category = BalanceCategory.find_or_create_by(name: work_data["balance_category"]["name"])
    end
    if work_data["style"]
      work.style = Style.find_or_create_by(name: work_data["style"]["name"])
    end
    if work_data["medium"]
      work.medium = Medium.find_or_create_by(name: work_data["medium"]["name"])
    end
    if work_data["condition_work"]
      work.condition_work = Condition.find_or_create_by(name: work_data["condition_work"]["name"])
    end
    if work_data["condition_frame"]
      work.condition_frame = Condition.find_or_create_by(name: work_data["condition_frame"]["name"])
    end
    if work_data["frame_type"]
      work.frame_type = FrameType.find_or_create_by(name: work_data["frame_type"]["name"])
    end
    if work_data["subset"]
      work.subset = Subset.find_or_create_by(name: work_data["subset"]["name"])
    end
    if work_data["work_status"]
      work.work_status = WorkStatus.find_or_create_by(name: work_data["work_status"]["name"])
    end
    if work_data["cluster_name"]
      work.cluster = Cluster.find_or_create_by(name: work_data["cluster_name"], collection_id: base_collection.id)
    end

    if work_data["old_data"]
      begin
        work.old_data = JSON.parse(work_data["old_data"])
      rescue
        work.old_data = {data: work_data["old_data"]}
      end
    end

    # HAS MANY
    work_data["appraisals"]&.each do |appraisal_data|
      work.appraisals << Appraisal.create(appraisal_data.merge({appraisee: work}))
    end
    work_data["techniques"]&.each do |technique|
      work.techniques << Technique.find_or_create_by(name: technique["name"])
    end
    work_data["artists"]&.each do |artist_data|
      cleaned_artist_data = {
        "place_of_birth" => artist_data["place_of_birth"],
        "place_of_death" => artist_data["place_of_death"],
        "year_of_birth" => artist_data["year_of_birth"],
        "year_of_death" => artist_data["year_of_death"],
        "description" => artist_data["description"],
        "first_name" => artist_data["first_name"],
        "prefix" => artist_data["prefix"],
        "last_name" => artist_data["last_name"],
        "rkd_artist_id" => artist_data["rkd_artist_id"],
        "place_of_death_geoname_id" => artist_data["place_of_death_geoname_id"],
        "place_of_birth_geoname_id" => artist_data["place_of_birth_geoname_id"],
        "date_of_birth" => artist_data["date_of_birth"],
        "date_of_death" => artist_data["date_of_death"],
        "artist_name" => artist_data["artist_name"],
        "other_structured_data" => artist_data["other_structured_data"],
        "old_data" => artist_data["old_data"]
      }

      artist = if cleaned_artist_data["rkd_artist_id"]
        Artist.find_by(rkd_artist_id: cleaned_artist_data["rkd_artist_id"])
      elsif artist_data["year_of_birth"] && artist_data["first_name"] && artist_data["last_name"]
        Artist.find_by(year_of_birth: artist_data["year_of_birth"], first_name: artist_data["first_name"], last_name: artist_data["last_name"])
      end
      artist ||= Artist.find_or_create_by(cleaned_artist_data)

      work.artists << artist if artist
    end
    work_data["themes"]&.each do |theme|
      work.themes << (Theme.find_by(name: theme["name"], collection_id: nil) || Theme.find_or_create_by(name: theme["name"], collection_id: base_collection.id))
    end

    work_data["damage_types"]&.each do |damage_type|
      work.damage_types << DamageType.find_or_create_by(name: damage_type["name"])
    end
    work_data["frame_damage_types"]&.each do |frame_damage_type|
      work.frame_damage_types << FrameDamageType.find_or_create_by(name: frame_damage_type["name"])
    end
    work_data["sources"]&.each do |source|
      work.sources << Source.find_or_create_by(name: source["name"])
    end
    work_data["work_sets"]&.each do |work_set|
      work_set_type = WorkSetType.find_or_create_by(name: work_set["work_set_type"]["name"], count_as_one: work_set["work_set_type"]["count_as_one"], appraise_as_one: work_set["work_set_type"]["appraise_as_one"])
      work.work_sets << WorkSet.find_or_create_by(work_set_type: work_set_type, identification_number: work_set["identification_number"], appraisal_notice: work_set["appraisal_notice"], comment: work_set["comment"])
    end
    work_data["time_spans"]&.each do |time_span_data|
      contact_data = time_span_data["contact"]
      contact = if contact_data["external"] && contact_data["remote_data"]
        Contact.find_or_initialize_by(remote_data: contact_data["remote_data"], collection: base_collection, external: true)
      elsif contact_data["external"]
        Contact.find_or_initialize_by(url: contact_data["url"], collection: base_collection, external: true)
      else
        Contact.find_or_initialize_by(name: contact_data["name"].to_s, address: contact_data["address"], external: false, url: contact_data["url"], collection: base_collection)
      end
      contact.name = contact_data["name"]
      contact.address = contact_data["address"]
      contact.collection = base_collection
      contact.save
      time_span = TimeSpan.find_or_initialize_by(contact: contact, starts_at: time_span_data["starts_at"], subject: work, uuid: time_span_data["uuid"], classification: time_span_data["classification"], collection: base_collection)
      time_span.ends_at = time_span_data["ends_at"] if time_span_data["ends_at"].present?
      time_span.status = time_span_data["status"]
      work.time_spans << time_span
      # time_span.save
    end

    # TODO:
    # has_and_belongs_to_many :attachments
    # has_and_belongs_to_many :library_items
    # has_many :messages, as: :subject_object

    if work.save
      data = {}
      data[:significantly_updated_at] = work_data["significantly_updated_at"]
      data[:updated_at] = work_data["updated_at"] if work_data["updated_at"]

      work.update_columns(data)
    else
      binding.irb if Rails.env.test?
      raise ::ImportCollection::ImportError.new("Import of work with id #{work_data["id"]} failed; #{work.errors.messages.map(&:to_s).to_sentence}")
    end
  rescue PG::UniqueViolation
    # ignore
  rescue ActiveRecord::RecordNotUnique
    # ignore
  end

  def write_json
    json = JSON.parse(file.read)
    json = json.is_a?(Array) ? json : json["data"]
    json.each do |work_data|
      ImportWriteWorkJson.perform_async(id, work_data)
    end
  end
end
