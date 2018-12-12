class Ability
  include CanCan::Ability

  def initialize(user)
    # [:admin, :qkunst, :appraiser, :facility_manager, :read_only]
    if user
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

        can :access_valuation, Collection
        can :download_datadump, Collection
        can :download_photos, Collection
        can :manage, Collection, id: user.accessible_collections.map(&:id)
        can :read_report, Collection
        can :read_status, Collection
        can :read_valuation, Collection
        can :read_valuation_reference, Collection
        can :refresh, Collection
        can :update_status, Collection

        can :read_information_back, Work
        can :read_internal_comments, Work
        can :tag, Work

        can :update, User
        cannot :destroy, User
        cannot :edit_admin, User
      elsif user.appraiser?
        can [:create, :update, :read, :manage_collection], Artist
        can [:create, :update], ArtistInvolvement

        can :show, RkdArtist
        can :copy, RkdArtist

        can :manage, Appraisal

        can :read_report, Collection
        can :read_status, Collection
        can :read_valuation, Collection
        can :read_valuation_reference, Collection
        can :refresh, Collection

        can :read_information_back, Work
        can :read_internal_comments, Work

        can :tag, Work
      elsif user.qkunst?
        can [:create, :update, :read, :manage_collection], Artist
        can [:create, :update], ArtistInvolvement

        can :show, RkdArtist
        can :copy, RkdArtist

        can :read_report, Collection
        can :read_status, Collection
        can :refresh, Collection

        can :read_information_back, Work
        can :read_internal_comments, Work
        can :tag, Work
      elsif user.facility_manager?
        can [:read], Artist

        can :read_report, Collection
        can :download_photos, Collection
        can :read_status, Collection
        can :read_valuation, Collection

        can :read_information_back, Work
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
