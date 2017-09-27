database_fields = (Work.column_names.collect{|a| a.to_sym unless a.ends_with?("_id")}.compact-[:market_value, :replacement_value, :purchase_price, :price_reference, :internal_comments, :valuation_on])

json.array!(@works) do |work|
  # when finished development, this may become static
  json.extract! work, *database_fields

  #
  # belongs_to :collection
  # belongs_to :created_by, :class_name=>User
  # belongs_to :source
  # has_and_belongs_to_many :sources
  # belongs_to :style
  # belongs_to :cluster
  # has_and_belongs_to_many :artists
  # has_and_belongs_to_many :object_categories
  # has_and_belongs_to_many :techniques
  # belongs_to :medium
  # belongs_to :condition_work, :class_name=>Condition
  # has_and_belongs_to_many :damage_types
  # belongs_to :condition_frame, :class_name=>Condition
  # has_and_belongs_to_many :frame_damage_types
  # has_and_belongs_to_many :themes
  # belongs_to :subset
  # belongs_to :placeability
  # belongs_to :purchase_price_currency, :class_name=>Currency
  #
  json.sources(work.sources){ |attribute| json.extract! attribute, :name, :id  }
  json.artists(work.artists){ |attribute| json.extract! attribute, :name, :id, :first_name, :prefix, :last_name, :year_of_birth, :year_of_death }
  json.object_categories(work.object_categories){ |attribute| json.extract! attribute, :name, :id  }
  json.techniques(work.techniques){ |attribute| json.extract! attribute, :name, :id  }
  json.damage_types(work.damage_types){ |attribute| json.extract! attribute, :name, :id  }
  json.frame_damage_types(work.frame_damage_types){ |attribute| json.extract! attribute, :name, :id  }
  json.themes(work.themes){ |attribute| json.extract! attribute, :name, :id  }

  json.style{ json.extract! work.style, :name, :id } if work.style
  json.cluster{ json.extract! work.cluster, :name, :id } if work.cluster
  json.medium{ json.extract! work.medium, :name, :id } if work.medium
  json.condition_work{ json.extract! work.condition_work, :name, :id } if work.condition_work
  json.condition_frame{ json.extract! work.condition_frame, :name, :id } if work.condition_frame
  json.subset{ json.extract! work.subset, :name, :id } if work.subset
  json.placeability{ json.extract! work.placeability, :name, :id } if work.placeability

  json.artist_name_rendered work.artist_name_rendered
  json.artist_name_rendered_without_years_nor_locality work.artist_name_rendered_without_years_nor_locality
  json.frame_size work.frame_size
  json.work_size work.work_size
  json.object_format_code work.object_format_code

  json.url collection_work_url(work.collection, work)
end
