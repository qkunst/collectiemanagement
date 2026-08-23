# frozen_string_literal: true

# Work::Location is a concern that deals with location related functionality.
# A work *may* be related to a MainLocation. The concept of MainLocation did not exist, but when it
# exists it replaces the function of the #location attribute.
# The location attribute is still used for caching, and hence can be used for e.g. sorting.
#
#  location                                            :string
#  location_detail                                     :string
#  location_floor                                      :string
#  main_location_id                                    :integer
module Work::Location
  extend ActiveSupport::Concern

  included do
    before_save :update_location_with_main_location
    belongs_to :main_location, optional: true, class_name: "::Location"

    normalize_attributes :location, :location_floor, :location_detail

    scope :order_by_location, -> { order(:location, Arel.sql("works.location_floor = '-3' DESC, works.location_floor = '-2' DESC, works.location_floor = '-1' DESC, works.location_floor = '0' DESC, works.location_floor = 'BG' DESC"), :location_floor, :location_detail) }

    def location_history(skip_current: false, empty_locations: true)
      location_versions = []
      uniq_location_versions = []
      versions.each_with_index do |version, index|
        location_versions[index] = {created_at: version.created_at, event: version.event, user: User.where(id: version.whodunnit).first&.name, location: nil, location_floor: nil, location_detail: nil}
        if version.object && (index > 0)
          reified_object = Work.new(YAML.safe_load(version.object, permitted_classes: ::ActiveRecord.yaml_column_permitted_classes, aliases: true).select { |k, v| [k, v] if ["location", "location_floor", "location_detail"].include?(k) })
          location_versions[index - 1][:location] = reified_object.location
          location_versions[index - 1][:location_floor] = reified_object.location_floor
          location_versions[index - 1][:location_detail] = reified_object.location_detail
        end
      end

      # complete with latest info
      index = location_versions.count

      if index > 0
        location_versions[index - 1][:location] = location
        location_versions[index - 1][:location_floor] = location_floor
        location_versions[index - 1][:location_detail] = location_detail

        # filter out irrelevant changes
        uniq_location_versions = [location_versions[0]]
        location_versions.each do |location_version|
          last_uniq_location_version = uniq_location_versions.last
          last_uniq_location_description = last_uniq_location_version.fetch_values(:location, :location_floor, :location_detail).join("")
          location_version_description = location_version.fetch_values(:location, :location_floor, :location_detail).join("")

          if (last_uniq_location_description != location_version_description) && (empty_locations || !location_version_description.blank?)
            uniq_location_versions << location_version
          end
        end
        if skip_current && (empty_locations == true || location_description)
          uniq_location_versions.pop
        end
        uniq_location_versions
      else
        []
      end
    end

    def main_location_id= id
      self.main_location = if id.is_a?(Integer) || id.to_s.match(/\A\d+$/)
        ::Location.find(id)
      elsif id.blank?
        nil
      else
        ::Location.find_or_create_by_name_and_collection(id, collection.super_base_collection)
      end
    end

    def location_description
      rv = [location, location_floor, location_detail].compact.map(&:strip).compact_blank.join("; ")
      rv.presence
    end

    def restore_last_location_if_blank!
      unless location_description
        prev_location = location_history(skip_current: true, empty_locations: false).last
        if prev_location
          self.location = prev_location[:location]
          self.location_detail = prev_location[:location_detail]
          self.location_floor = prev_location[:location_floor]
          save!
        end
      end
    end

    private

    def update_location_with_main_location
      self.location = main_location.name if main_location
    end
  end

  class_methods do
    def collect_locations
      rv = {}
      group(:location).count.sort { |a, b| a[0].to_s.downcase <=> b[0].to_s.downcase }.each { |a| rv[a[0]] = {count: a[1], subs: []} }
      rv
    end
  end
end
