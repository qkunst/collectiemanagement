# frozen_string_literal: true

class Ability
  include CanCan::Ability

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

        can [:manage, :download_photos, :download_datadump, :access_valuation, :read_report, :read_extended_report,:read_valuation, :read_status, :access_valuation, :read_valuation, :read_valuation_reference, :refresh, :update_status], Collection, id: accessible_collection_ids

        can [:edit_photos, :read_information_back, :read_internal_comments, :manage_location, :tag, :show_details], Work

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

        can [:manage, :download_photos, :download_datadump, :access_valuation, :read_report, :read_extended_report, :read_valuation, :read_status, :read_valuation_reference, :refresh, :update_status], Collection, id: accessible_collection_ids

        can [:read, :tag, :edit_photos, :read_information_back, :manage_location, :manage, :read_internal_comments, :show_details], Work, collection_id: accessible_collection_ids
        can :manage, Message

        can :update, User
        cannot [:destroy, :edit_admin], User
      elsif user.compliance?
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

        can [:read, :read_report, :read_extended_report, :read_status, :read_valuation, :read_valuation_reference,  :refresh], Collection, id: accessible_collection_ids

        can [:read, :read_information_back, :read_internal_comments, :tag, :edit, :manage_location, :edit_photos, :show_details], Work, collection_id: accessible_collection_ids

        can :tag, Work
      elsif user.registrator?
        can [:create, :update, :read, :manage_collection], Artist
        can [:create, :update], ArtistInvolvement
        can [:read, :copy], RkdArtist

        can [:read, :read_report, :read_extended_report, :read_status, :refresh], Collection, id: accessible_collection_ids

        can [:read, :edit_photos, :edit, :manage_location, :read_information_back, :read_internal_comments, :tag, :show_details], Work, collection_id: accessible_collection_ids
      elsif user.facility_manager?
        can [:read], Artist
        can [:read, :read_report, :read_status, :download_photos, :read_valuation], Collection, id: accessible_collection_ids
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
