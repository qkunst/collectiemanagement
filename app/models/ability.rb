class Ability
  include CanCan::Ability

  def initialize(user)
    # [:admin, :qkunst, :appraiser, :facility_manager, :read_only]
    if user
      if user.admin?
        can :manage, :all

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
      elsif user.appraiser?
        can :manage, Appraisal

        can :read_report, Collection
        can :read_status, Collection
        can :read_valuation, Collection
        can :read_valuation_reference, Collection
        can :refresh, Collection

        can :read_information_back, Work
        can :read_internal_comments, Work
      elsif user.qkunst?
        can :read_report, Collection
        can :read_status, Collection
        can :refresh, Collection

        can :read_information_back, Work
        can :read_internal_comments, Work
      elsif user.facility_manager?
        can :read_report, Collection
        can :download_photos, Collection
        can :read_status, Collection
        can :read_valuation, Collection

        can :read_information_back, Work
      elsif user.read_only?

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
