# frozen_string_literal: true

class Ability
  class TestUser
    def initialize(role)
      @role = role
    end
    def role
      @role
    end
    def accessible_collections
      []
    end
    def admin?
      @role == :admin
    end
    def advisor?
      @role == :advisor
    end
    def compliance?
      @role == :compliance
    end
    def appraiser?
      @role == :appraiser
    end
    def registrator?
      @role == :qkunst || @role == :registrator
    end
    def facility_manager?
      @role == :facility_manager
    end
    def read_only?
      @role == :read_only
    end
  end

  include CanCan::Ability

  def self.report_field_abilities
    approles = User::ROLES - [:qkunst]

    all_fields = Ability.new(TestUser.new(:admin)).editable_work_fields_grouped

    field_report = {header: [], data: {}}
    all_fields.each do |model_key, model_fields|
      field_report[:data][model_key] = {}
      model_fields.each do |attribute|
        field_report[:data][model_key][attribute] = []
      end
    end

    abilities = {}

    approles.each do |role|
      user = TestUser.new(role)
      ability = Ability.new(user)
      abilities[role] = ability
      field_report[:header] << {ability: ability, user: user}
    end

    all_fields.each do |model_key, model_fields|
      model_fields.each do |attribute|
        field_report[:header].each_with_index do |ability, index|
          contains_attribute = (ability[:ability].editable_work_fields_grouped[model_key] && ability[:ability].editable_work_fields_grouped[model_key].include?(attribute))
          field_report[:data][model_key][attribute][index] = contains_attribute
        end
      end
    end

    field_report
  end

  def self.report_abilities
    approles = User::ROLES - [:qkunst]

    ability_report = {header:[], data:{}}

    permissions_per_thing = {}

    approles.each do |role|
      user = TestUser.new(role)
      ability = Ability.new(user)

      ability.permissions[:can].each do |permission, things|
        things.each do |thing, _|
          permissions_per_thing[thing] ||= []
          permissions_per_thing[thing] << permission unless permissions_per_thing[thing].include? permission
        end
      end
    end

    approles.each do |role|
      user = TestUser.new(role)
      ability = Ability.new(user)

      ability_report[:header] << {ability: ability, user: user}

      permissions_per_thing.each do |thing, permissions|
        thing_i18n = I18n.t thing.downcase, scope: [:activerecord, :models]
        ability_report[:data][thing_i18n] ||= {}
        permissions.each do |permission|
          permission_i18n = I18n.t permission, scope: [:abilities]
          ability_report[:data][thing_i18n][permission_i18n] ||= []

          thing_constantize = begin; thing.constantize; rescue; thing; end
          ability_report[:data][thing_i18n][permission_i18n] << ability.can?(permission, thing_constantize)
        end

      end
    end


    ability_report
  end


  def initialize(user)
    # [:admin, :qkunst, :appraiser, :facility_manager, :read_only]
    if user
      alias_action :review_collection, :modify_collection, :review_collection, to: :manage_collection
      alias_action :show, :index, to: :read
      alias_action :read_location, :edit_location, to: :manage_location

      accessible_collection_ids = user.accessible_collections.map(&:id)

      if user.admin?
        can :manage, :all

        can [:clean, :combine, :manage_collection], Artist

        can :manage_collection, Cluster
        can :manage_collection, Collection
        can :manage_collection, CustomReport
        can :manage, CustomReport
        can :manage, Message

        can [:read, :copy], RkdArtist

        can :edit_visibility, Attachment

        can [:batch_edit, :manage, :download_photos, :download_datadump, :access_valuation, :read_report, :read_extended_report,:read_valuation, :read_status, :access_valuation, :read_valuation, :read_valuation_reference, :refresh, :update_status], Collection, id: accessible_collection_ids

        can [:edit_photos, :read_information_back, :read_internal_comments, :write_internal_comments, :manage_location, :tag, :show_details], Work, collection_id: accessible_collection_ids

        can [:destroy, :edit_admin], User
      elsif user.advisor?
        can [:create, :update, :read, :manage_collection], Artist
        can [:create, :update], ArtistInvolvement

        can [:read, :copy], RkdArtist

        can :manage, Appraisal
        can :manage, CustomReport, collection_id: accessible_collection_ids

        can :manage_collection, :all
        cannot :manage_collection, ImportCollection

        can [:create, :update, :edit_visibility], Attachment do |attachment|
          (attachment.attache_type == "Collection" and accessible_collection_ids.include? attachment.attache_id) or
          (attachment.attache_type == "Work" and accessible_collection_ids.include? attachment.attache.collection.id)
        end

        can :create, Collection, parent_collection_id: accessible_collection_ids

        can [:batch_edit, :manage, :download_photos, :download_datadump, :access_valuation, :read_report, :read_extended_report, :read_valuation, :read_status, :read_valuation_reference, :refresh, :update_status], Collection, id: accessible_collection_ids

        can [:read, :edit, :tag, :edit_photos, :read_information_back, :manage_location, :manage, :read_internal_comments, :write_internal_comments, :show_details], Work, collection_id: accessible_collection_ids
        can :manage, Message

        can :update, User
        cannot [:destroy, :edit_admin], User
      elsif user.compliance?
        # READ ONLY, BUT FULL ACCESS
        cannot [:create, :edit, :update, :tag], :all

        can [:read, :review_collection], Artist
        can :read, RkdArtist

        can :review_collection, Cluster, collection_id: accessible_collection_ids
        can :review_collection, CustomReport, collection_id: accessible_collection_ids
        can :review_collection, Reminder, collection_id: accessible_collection_ids
        can :review_collection, Theme, collection_id: accessible_collection_ids
        can :review_collection, ImportCollection, collection_id: accessible_collection_ids
        can :review_collection, Owner, collection_id: accessible_collection_ids

        can :read, Appraisal
        can :read, CustomReport, collection_id: accessible_collection_ids

        can :read, ImportCollection, collection_id: accessible_collection_ids
        can :read, Reminder, collection_id: accessible_collection_ids
        can :read, Attachment
        can :read, Message

        can [:read, :review, :review_collection, :access_valuation, :download_datadump, :download_photos, :read_report, :read_extended_report, :read_status, :read_valuation, :read_valuation_reference], Collection, id: accessible_collection_ids

        can :read, Attachment do |attachment|
          (attachment.attache_type == "Collection" and accessible_collection_ids.include? attachment.attache_id) or
          (attachment.attache_type == "Work" and accessible_collection_ids.include? attachment.attache.collection.id)
        end

        can [:read, :read_information_back, :read_location, :read_internal_comments, :show_details], Work, collection_id: accessible_collection_ids

        can :read, User
      elsif user.appraiser?
        can [:create, :update, :read, :manage_collection], Artist
        can [:create, :update], ArtistInvolvement
        can [:read, :copy], RkdArtist

        can :manage, Appraisal
        can :read, CustomReport, collection_id: accessible_collection_ids
        can [:create, :read], Message
        can :edit, Message do |message|
          message && message.from_user == user && message.replies.count == 0 && message.unread
        end

        can [:batch_edit, :read, :read_report, :read_extended_report, :read_status, :read_valuation, :read_valuation_reference,  :refresh], Collection, id: accessible_collection_ids

        can [:read, :edit, :read_information_back, :read_internal_comments, :write_internal_comments, :tag, :edit, :manage_location, :edit_photos, :show_details], Work, collection_id: accessible_collection_ids

        can :tag, Work
      elsif user.registrator?
        can [:create, :update, :read, :manage_collection], Artist
        can [:create, :update], ArtistInvolvement
        can [:read, :copy], RkdArtist

        can [:batch_edit, :read, :read_report, :read_extended_report, :read_status, :refresh], Collection, id: accessible_collection_ids

        can [:read, :edit_photos, :edit, :manage_location, :read_information_back, :read_internal_comments, :write_internal_comments, :tag, :show_details], Work, collection_id: accessible_collection_ids
      elsif user.facility_manager?
        can [:read], Artist
        can [:read, :read_report, :read_status, :download_photos, :read_valuation], Collection, id: accessible_collection_ids
        can :batch_edit, Collection, id: accessible_collection_ids # note that a facility manager only has access to a limited set of fields
        can [:read, :read_information_back, :manage_location, :show_details], Work, collection_id: accessible_collection_ids

        can :create, Message
        can :read, Message, qkunst_private: false
      elsif user.read_only?
        can [:read], Artist
        can :read, Collection, id: accessible_collection_ids
        can :read, Work, collection_id: accessible_collection_ids
      end

      cannot :manage, Collection, root: true
    end

    # centralize store of fields editable per user; this array is used for sanctioning input parameters and filtering forms
    def editable_work_fields
      permitted_fields = []
      permitted_fields += [:location_detail, :location, :location_floor] if can?(:edit_location, Work)
      permitted_fields += [:internal_comments] if can?(:write_internal_comments, Work)
      permitted_fields += [
        :photo_front, :photo_back, :photo_detail_1, :photo_detail_2,
        :remove_photo_front, :remove_photo_back, :remove_photo_detail_1, :remove_photo_detail_2
      ] if can?(:edit_photos, Work)
      permitted_fields += [
        :inventoried, :refound, :new_found,
        :locality_geoname_id, :imported_at, :import_collection_id, :stock_number, :alt_number_1, :alt_number_2, :alt_number_3,
        :artist_unknown, :title, :title_unknown, :description, :object_creation_year, :object_creation_year_unknown, :medium_id, :frame_type_id,
        :signature_comments, :no_signature_present, :print, :print_unknown, :frame_height, :frame_width, :frame_depth, :frame_diameter,
        :height, :width, :depth, :diameter, :condition_work_id, :condition_work_comments, :condition_frame_id, :condition_frame_comments,
        :information_back, :other_comments, :source_comments, :subset_id,  :public_description,
        :grade_within_collection, :entry_status, :entry_status_description, :abstract_or_figurative, :medium_comments,
        :main_collection, :image_rights, :publish, :cluster_name, :collection_id, :cluster_id, :owner_id,
        :placeability_id, artist_ids:[], source_ids: [], damage_type_ids:[], frame_damage_type_ids:[], tag_list: [],
        theme_ids:[],  object_category_ids:[], technique_ids:[], artists_attributes: [
          :_destroy, :first_name, :last_name, :prefix, :place_of_birth, :place_of_death, :year_of_birth, :year_of_death, :description
        ]
        ] if can?(:edit, Work)
        permitted_fields += [
          :selling_price, :minimum_bid, :purchase_price, :purchased_on, :purchase_year, :selling_price_minimum_bid_comments,
          appraisals_attributes: [
            :appraised_on, :market_value, :replacement_value, :market_value_range, :replacement_value_range, :appraised_by, :reference
          ]
        ] if can?(:create, Appraisal)
      permitted_fields

    end

    def editable_work_fields_grouped
      return @fields if @fields
      fields = {
        works_attributes: [],
        artists_attributes: [],
        appraisals_attributes: []
      }

      editable_work_fields.each do |a|
        if a.is_a?(Symbol)
          fields[:works_attributes] << a
        elsif a.is_a?(Hash)
          fields.keys.each do |group|
            if a.keys.include?(group)
              a[group].select{|b| b.is_a?(Symbol)}.each do |c|
                fields[group] << c
              end
            end
          end
          a.select{|b| b.to_s.end_with?("ids")}.each do |key,value|
            fields[:works_attributes] << key
          end
        end
      end
      @fields = fields
    end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
