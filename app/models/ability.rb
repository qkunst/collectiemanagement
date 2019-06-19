# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # [:admin, :qkunst, :appraiser, :facility_manager, :read_only]
    if user
      alias_action :review_collection, :modify_collection, :review_collection, to: :manage_collection

      accessible_collection_ids = user.accessible_collections.map(&:id)

      if user.admin?
        can :manage, :all

        can :clean, Artist
        can :combine, Artist
        can :manage_collection, Artist

        can :manage_collection, Cluster
        can :manage_collection, Collection
        can :manage_collection, CustomReport

        can :show, RkdArtist
        can :copy, RkdArtist

        can :edit_visibility, Attachment
        can :edit_photos, Work

        can :access_valuation, Collection
        can :download_datadump, Collection
        can :download_photos, Collection
        can :read_report, Collection
        can :read_status, Collection
        can :read_valuation, Collection
        can :read_valuation_reference, Collection
        can :refresh, Collection
        can :update_status, Collection

        can :read_information_back, Work
        can :read_internal_comments, Work
        can :tag, Work

        can :destroy, User
        can :edit_admin, User

      elsif user.advisor?
        can [:create, :update, :read, :manage_collection], Artist
        can [:create, :update], ArtistInvolvement

        can :show, RkdArtist
        can :copy, RkdArtist

        can :manage, Appraisal

        can :edit_visibility, Attachment

        can :manage_collection, :all
        cannot :manage_collection, ImportCollection

        can :create, Collection, parent_collection_id: accessible_collection_ids
        can :access_valuation, Collection
        can :download_datadump, Collection
        can :download_photos, Collection
        can :manage, Collection, id: accessible_collection_ids
        can [:create, :update, :edit_visibility], Attachment do |attachment|
          (attachment.attache_type == "Collection" and accessible_collection_ids.include? attachment.attache_id) or
          (attachment.attache_type == "Work" and accessible_collection_ids.include? attachment.attache.collection.id)
        end
        can :read_report, Collection
        can :read_status, Collection
        can :read_valuation, Collection
        can :read_valuation_reference, Collection
        can :refresh, Collection
        can :update_status, Collection

        can :read_information_back, Work
        can :read_internal_comments, Work
        can :tag, Work
        can :destroy, Work
        can :edit_photos, Work

        can :update, User
        cannot :destroy, User
        cannot :edit_admin, User
      elsif user.compliance?
        cannot :create, :all
        cannot :update, :all
        cannot :tag, :all

        can [:read, :review_collection], Artist

        can :review_collection, Cluster, collection_id: accessible_collection_ids
        can :review_collection, CustomReport, collection_id: accessible_collection_ids
        can :review_collection, Reminder, collection_id: accessible_collection_ids
        can :review_collection, Theme, collection_id: accessible_collection_ids
        can :review_collection, ImportCollection, collection_id: accessible_collection_ids
        can :review_collection, Owner, collection_id: accessible_collection_ids

        can :show, RkdArtist
        can :read, Appraisal
        can :read, Attachment

        actions_on_collection = [:read, :review, :review_collection, :access_valuation, :download_datadump, :download_photos, :read_report, :read_status, :read_valuation, :read_valuation_reference]

        can actions_on_collection, Collection, parent_collection_id: accessible_collection_ids
        can actions_on_collection, Collection, id: accessible_collection_ids

        can [:read], Attachment do |attachment|
          (attachment.attache_type == "Collection" and accessible_collection_ids.include? attachment.attache_id) or
          (attachment.attache_type == "Work" and accessible_collection_ids.include? attachment.attache.collection.id)
        end

        can [:read, :read_information_back, :read_internal_comments], Work, collection_id: accessible_collection_ids

        can :read, User
      elsif user.appraiser?
        can [:create, :update, :read, :manage_collection], Artist
        can [:create, :update], ArtistInvolvement

        can :show, RkdArtist
        can :copy, RkdArtist

        can :manage, Appraisal

        actions_on_collection = [:read, :read_report, :read_status, :read_valuation, :read_valuation_reference, :refresh]

        can actions_on_collection, Collection, parent_collection_id: accessible_collection_ids
        can actions_on_collection, Collection, id: accessible_collection_ids

        can [:read, :read_information_back, :read_internal_comments, :tag, :edit], Work, collection_id: accessible_collection_ids

        can :tag, Work
      elsif user.registrator?
        can [:create, :update, :read, :manage_collection], Artist
        can [:create, :update], ArtistInvolvement

        can :show, RkdArtist
        can :copy, RkdArtist

        can :read_report, Collection
        can :read_status, Collection
        can :refresh, Collection

        can [:read, :edit_photos, :read_information_back, :read_internal_comments, :tag], Work, collection_id: accessible_collection_ids
      elsif user.facility_manager?
        can [:read], Artist

        can :read_report, Collection
        can :download_photos, Collection
        can :read_status, Collection
        can :read_valuation, Collection

        can :read_information_back, Work, collection_id: accessible_collection_ids
      elsif user.read_only?
        can [:show], Artist
      end
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
