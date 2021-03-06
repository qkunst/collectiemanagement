# frozen_string_literal: true

class Ability
  include CanCan::Ability

  #
  # alias_action :index, :show, :to => :read
  # alias_action :new, :to => :create
  # alias_action :edit, :to => :update

  include Report

  attr_reader :user

  def initialize(user)
    if user
      @user = user
      alias_action :review_collection, :review_collection_users, :modify_collection, :review_collection, to: :manage_collection # Manage related object in the context of a collection, but not outside collection
      alias_action :show, :index, to: :read
      alias_action :read_location, :edit_location, to: :manage_location

      # default role settings
      send("initialize_#{user.role}")

      # specific cross role functionality
      message_rules

      # special additional roles
      role_manager

      cannot :manage, Collection, root: true
    end
  end

  def accessible_collection_ids
    user.accessible_collection_ids
  end

  # centralize store of fields editable per user; this array is used for sanctioning input parameters and filtering forms
  def editable_work_fields
    permitted_fields = []
    permitted_fields += [:location_detail, :location, :location_floor, :work_status_id] if can?(:edit_location, Work)
    permitted_fields += [:internal_comments] if can?(:write_internal_comments, Work)
    if can?(:edit_photos, Work)
      permitted_fields += [
        :photo_front, :photo_back, :photo_detail_1, :photo_detail_2,
        :remove_photo_front, :remove_photo_back, :remove_photo_detail_1, :remove_photo_detail_2
      ]
    end
    if can?(:edit, Work)
      permitted_fields += [
        :inventoried, :refound, :new_found,
        :locality_geoname_id, :imported_at, :import_collection_id, :stock_number, :alt_number_1, :alt_number_2, :alt_number_3,
        :artist_unknown, :title, :title_unknown, :description, :object_creation_year, :object_creation_year_unknown, :medium_id, :frame_type_id,
        :signature_comments, :no_signature_present, :print, :print_unknown, :frame_height, :frame_width, :frame_depth, :frame_diameter,
        :height, :width, :depth, :diameter, :condition_work_id, :condition_work_comments, :condition_frame_id, :condition_frame_comments,
        :information_back, :other_comments, :subset_id, :public_description,
        :grade_within_collection, :entry_status, :entry_status_description, :abstract_or_figurative, :medium_comments,
        :main_collection, :image_rights, :publish, :cluster_name, :collection_id, :cluster_id, :owner_id, :permanently_fixed,
        :placeability_id, artist_ids: [], damage_type_ids: [], frame_damage_type_ids: [], tag_list: [],
                          theme_ids: [], object_category_ids: [], technique_ids: [], artists_attributes: [
                            :_destroy, :first_name, :last_name, :prefix, :place_of_birth, :place_of_death, :year_of_birth, :year_of_death, :description
                          ]
      ]
    end
    if can?(:create, WorkSet)
      permitted_fields += [
        work_set_attributes: [:identification_number, :work_set_type_id]
      ]
    end
    if can?(:edit_source_information, Work)
      permitted_fields += [
        :source_comments, source_ids: []
      ]
    end
    if can?(:edit_purchase_information, Work)
      permitted_fields += [
        :purchase_price, :purchased_on, :purchase_year
      ]
    end
    if can?(:create, Appraisal)
      permitted_fields += [
        :selling_price, :minimum_bid, :purchase_price, :purchased_on, :purchase_year, :selling_price_minimum_bid_comments, :purchase_price_currency_id, :balance_category_id,
        appraisals_attributes: [
          :appraised_on, :market_value, :replacement_value, :market_value_range, :replacement_value_range, :appraised_by, :reference, :notice
        ]
      ]
    end
    permitted_fields
  end

  # centralize store of fields editable per user; this array is used for sanctioning viewing
  def viewable_work_fields
    permitted_fields = [:alt_number_1, :alt_number_2, :alt_number_3, :object_creation_year, :object_categories, :techniques, :photo_front, :photo_back, :photo_detail_1, :photo_detail_2]
    permitted_fields += [:location_detail, :location, :location_floor, :work_status_id] if can?(:read_location, Work)
    permitted_fields += [:internal_comments] if can?(:read_internal_comments, Work)
    permitted_fields += [
    ]
    if can?(:edit, Work)
      permitted_fields += [
        :inventoried, :refound, :new_found,
        :locality_geoname_id, :imported_at, :import_collection_id, :stock_number, :alt_number_1, :alt_number_2, :alt_number_3,
        :artist_unknown, :title, :title_unknown, :description, :object_creation_year, :object_creation_year_unknown, :medium_id, :frame_type_id,
        :signature_comments, :no_signature_present, :print, :print_unknown, :frame_height, :frame_width, :frame_depth, :frame_diameter,
        :height, :width, :depth, :diameter, :condition_work_id, :condition_work_comments, :condition_frame_id, :condition_frame_comments,
        :information_back, :other_comments, :subset_id, :public_description,
        :grade_within_collection, :entry_status, :entry_status_description, :abstract_or_figurative, :medium_comments,
        :main_collection, :image_rights, :publish, :cluster_name, :collection_id, :cluster_id, :owner_id, :permanently_fixed,
        :placeability_id, artist_ids: [], damage_type_ids: [], frame_damage_type_ids: [], tag_list: [],
                          theme_ids: [], object_category_ids: [], technique_ids: [], artists_attributes: [
                            :_destroy, :first_name, :last_name, :prefix, :place_of_birth, :place_of_death, :year_of_birth, :year_of_death, :description
                          ]
      ]
    end
    if can?(:create, WorkSet)
      permitted_fields += [
        work_set_attributes: [:identification_number, :work_set_type_id]
      ]
    end
    if can?(:edit_source_information, Work)
      permitted_fields += [
        :source_comments, source_ids: []
      ]
    end
    if can?(:edit_purchase_information, Work)
      permitted_fields += [
        :purchase_price, :purchased_on, :purchase_year
      ]
    end
    if can?(:create, Appraisal)
      permitted_fields += [
        :selling_price, :minimum_bid, :purchase_price, :purchased_on, :purchase_year, :selling_price_minimum_bid_comments, :purchase_price_currency_id, :balance_category_id,
        appraisals_attributes: [
          :appraised_on, :market_value, :replacement_value, :market_value_range, :replacement_value_range, :appraised_by, :reference, :notice
        ]
      ]
    end
    permitted_fields
  end

  # def viewable_work_fields
  #   editable_work_fields
  # end

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
          if a.key?(group)
            a[group].select { |b| b.is_a?(Symbol) }.each do |c|
              fields[group] << c
            end
          end
        end
        a.select { |b| b.to_s.end_with?("ids") }.each do |key, value|
          fields[:works_attributes] << key
        end
      end
    end
    @fields = fields
  end

  private

  def message_rules
    can :read, Message, from_user: user
    can :read, Message do |message|
      (message.conversation_start_message && message.conversation_start_message.from_user == user) ||
        (message.conversation_start_message && message.conversation_start_message.to_user == user) ||
        (message.subject_object && can?(:read, message.subject_object))
    end
  end

  def role_manager
    if user.role_manager?
      can [:review_collection_users], Collection, id: accessible_collection_ids

      # ROLES = [:admin, :advisor, :compliance, :qkunst, :appraiser, :facility_manager, :read_only]

      can [:read, :update, :update_advisor, :update_compliance, :update_qkunst, :update_appraiser, :update_facility_manager, :update_read_only], User do |object_user|
        (((accessible_collection_ids & object_user.accessible_collection_ids) != []) || object_user.collection_ids.empty?) && (!object_user.admin? || user.admin?) && (object_user != user || user.admin?)
      end
      cannot [:update], User, id: user.id unless user.admin?
    end
  end

  def initialize_admin
    can :manage, :all

    can [:clean, :combine, :manage_collection], Artist

    can :manage_collection, Cluster
    can :manage_collection, Collection
    can :read_api, Collection
    can :filter_report, Collection
    can :manage_collection, CustomReport
    can :manage, CustomReport
    can :manage, Message

    can [:read, :copy], RkdArtist

    can [:edit_visibility, :update], Attachment, collection_id: accessible_collection_ids
    can :manage, LibraryItem

    can [:read_api, :batch_edit, :manage, :download_photos, :download_datadump, :download_pdf, :download_public_datadump, :access_valuation, :read_report, :read_extended_report, :read_valuation, :read_status, :access_valuation, :read_valuation_reference, :refresh, :update_status, :review_modified_works, :destroy], Collection, id: accessible_collection_ids

    can [:read_advanced_properties, :read_api, :edit_photos, :edit_source_information, :read_information_back, :create, :read_internal_comments, :write_internal_comments, :manage_location, :tag, :view_location_history, :show_details], Work, collection_id: accessible_collection_ids
    can :manage, Message

    can [:destroy, :edit_admin, :manage], User
    can [:read_without_collection, :manage], WorkSet
  end

  def initialize_advisor
    can [:create, :read, :update, :manage_collection], Artist
    can [:create, :read, :update], ArtistInvolvement
    can [:create, :read, :update, :destroy], WorkSet

    can [:read, :copy], RkdArtist

    can [:create, :update, :read], Appraisal
    can [:create, :update, :read], CustomReport, collection_id: accessible_collection_ids
    can :manage, LibraryItem, collection_id: accessible_collection_ids

    can :manage_collection, :all
    can :manage, Cluster, collection_id: accessible_collection_ids
    cannot :manage_collection, ImportCollection

    can [:create, :update, :edit_visibility, :index], Attachment, collection_id: accessible_collection_ids

    can :create, Collection, parent_collection_id: accessible_collection_ids

    can [:read_api, :batch_edit, :create, :update, :read, :download_photos, :download_datadump, :download_pdf, :download_public_datadump, :access_valuation, :read_report, :read_extended_report, :read_valuation, :read_status, :read_valuation_reference, :refresh, :update_status, :review_modified_works, :review, :destroy], Collection, id: accessible_collection_ids

    can [:read_advanced_properties, :read_api, :read, :create, :tag, :update, :edit_photos, :read_information_back, :manage_location, :read_internal_comments, :edit_purchase_information, :edit_source_information, :write_internal_comments, :view_location_history, :show_details], Work, collection_id: accessible_collection_ids
    can [:create, :update, :read, :complete], Message
  end

  def initialize_compliance
    # READ ONLY, BUT FULL ACCESS
    cannot [:create, :edit, :update, :tag], :all

    can [:read, :review_collection], Artist
    can :read, RkdArtist
    can [:read], WorkSet

    can :review_collection, Cluster, collection_id: accessible_collection_ids
    can :review_collection, CustomReport, collection_id: accessible_collection_ids
    can :review_collection, Reminder, collection_id: accessible_collection_ids
    can :review_collection, Theme, collection_id: accessible_collection_ids
    can :review_collection, ImportCollection, collection_id: accessible_collection_ids
    can :review_collection, Owner, collection_id: accessible_collection_ids
    can :review_collection, User
    can :read, Appraisal
    can :read, CustomReport, collection_id: accessible_collection_ids

    can :read, ImportCollection, collection_id: accessible_collection_ids
    can :read, Reminder, collection_id: accessible_collection_ids
    can :read, LibraryItem, collection_id: accessible_collection_ids
    can :read, Attachment, collection_id: accessible_collection_ids
    can [:read, :create], Message

    can [:read, :review, :review_collection, :review_collection_users, :access_valuation, :download_datadump, :download_pdf, :download_public_datadump, :download_photos, :read_report, :read_extended_report, :read_status, :read_valuation, :review_modified_works], Collection, id: accessible_collection_ids

    can :read, Attachment, collection_id: accessible_collection_ids

    can [:read_advanced_properties, :read, :read_information_back, :read_location, :read_internal_comments, :view_location_history, :show_details], Work, collection_id: accessible_collection_ids

    can :read, User

    can :create, Message
    can :read, Message, qkunst_private: false
  end

  def initialize_appraiser
    can [:create, :update, :read, :manage_collection], Artist
    can [:create, :update], ArtistInvolvement
    can [:read, :copy], RkdArtist
    can [:create, :read, :update, :destroy], WorkSet

    can [:create, :update, :read], Appraisal do |appraisal|
      appraisal.appraisee.can_be_accessed_by_user?(user)
    end
    can :read, CustomReport, collection_id: accessible_collection_ids
    can [:create, :read], Message
    can :edit, Message do |message|
      message && message.from_user == user && message.replies.count == 0 && message.unread
    end

    can [:read, :create, :update], LibraryItem, collection_id: accessible_collection_ids

    can [:batch_edit, :read, :read_report, :read_extended_report, :read_status, :read_valuation, :read_valuation_reference, :refresh], Collection, id: accessible_collection_ids

    can [:read_advanced_properties, :read, :edit, :create, :read_information_back, :read_internal_comments, :write_internal_comments, :tag, :edit, :edit_purchase_information, :edit_source_information, :manage_location, :edit_photos, :view_location_history, :show_details], Work, collection_id: accessible_collection_ids

    can [:create, :index, :update], Attachment, collection_id: accessible_collection_ids

    can :tag, Work
  end

  def initialize_registrator
    can [:create, :update, :read, :manage_collection], Artist
    can [:create, :update], ArtistInvolvement
    can [:read, :copy], RkdArtist
    can [:create, :read, :update], WorkSet

    can [:read, :create, :update], Attachment, collection_id: accessible_collection_ids

    can [:read, :create, :update], LibraryItem, collection_id: accessible_collection_ids

    can [:batch_edit, :read, :read_report, :read_extended_report, :read_status, :refresh], Collection, id: accessible_collection_ids

    can [:read_advanced_properties, :read, :edit_photos, :edit, :create, :manage_location, :read_information_back, :read_internal_comments, :edit_source_information, :write_internal_comments, :tag, :view_location_history, :show_details], Work, collection_id: accessible_collection_ids
  end
  alias_method :initialize_qkunst, :initialize_registrator

  def initialize_facility_manager
    can [:read], Artist
    can [:read, :read_report, :read_status, :read_valuation, :download_pdf, :download_photos, :batch_edit, :review_modified_works], Collection, id: accessible_collection_ids
    can [:read_advanced_properties, :read, :read_information_back, :manage_location, :view_location_history, :show_details], Work, collection_id: accessible_collection_ids
    can [:read], LibraryItem, collection_id: accessible_collection_ids

    can :create, Message
    can [:read, :show], Message, qkunst_private: [false, nil]
  end

  def initialize_read_only
    can [:read], Artist
    can :read, Collection, id: accessible_collection_ids
    can :read, Work, collection_id: accessible_collection_ids
  end
end
