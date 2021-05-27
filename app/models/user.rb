# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_paper_trail

  ROLES = [:admin, :advisor, :compliance, :qkunst, :appraiser, :facility_manager, :read_only]
  ADMIN_DOMAINS = ["qkunst.nl"]
  ADMIN_OAUTH_PROVIDERS = ["google_oauth2"]

  devise :database_authenticatable, :registerable, :omniauthable, :confirmable,
    :recoverable, :rememberable, :trackable, :validatable, :timeoutable, omniauth_providers: [:google_oauth2, :azureactivedirectory]

  store :collection_accessibility_serialization
  store :filter_params
  store :raw_open_id_token

  after_update :schedule_sync_stored_user_names

  has_and_belongs_to_many :collections

  scope :admin, -> { where(admin: true, oauth_provider: ADMIN_OAUTH_PROVIDERS, domain: ADMIN_DOMAINS) }
  scope :not_admin, -> { where.not(admin: true) }
  scope :advisor, -> { where(advisor: true).where(admin: [false, nil]) }
  scope :appraiser, -> { where(appraiser: true).where(admin: [false, nil], advisor: [false, nil]) }
  scope :registrator, -> { where(qkunst: true).where(admin: [false, nil], appraiser: [false, nil], advisor: [false, nil]) }
  scope :qkunst, -> { where(qkunst: true) }
  scope :other, -> { where(qkunst: [false, nil], admin: [false, nil], appraiser: [false, nil], advisor: [false, nil]) }
  scope :has_collections, -> { joins(:collections).uniq }
  scope :receive_mails, -> { where(receive_mails: true) }
  scope :inactive, -> { other.left_outer_joins(:collections).where(collections_users: {id: nil}) }
  scope :confirmed, -> { where.not(confirmed_at: nil) }

  before_save :serialize_collection_accessibility!

  def qkunst?
    read_attribute(:qkunst) || admin? || appraiser? || advisor?
  end

  def role
    roles.first
  end

  def roles
    rv = User::ROLES.collect { |r|
      r if methods.include?(r) && send(r)
    }
    (rv.compact + [:read_only])
  end

  def ability
    @ability ||= Ability.new(self)
  end

  def admin_with_favorites?
    collections.count > 0
  end

  def accessible_collections
    @accessible_collections ||= if super_admin?
      Collection.all
    elsif admin?
      Collection.qkunst_managed.all
    else
      collections.expand_with_child_collections
    end
  end

  def accessible_collection_ids
    @accessible_collection_ids ||= accessible_collections.pluck(:id)
  end

  def accessible_collections_sorted_by_label
    accessible_collections.sort_by(&:to_label)
  end

  def accessible_works
    return Work.all if admin?
    Work.where(collection_id: accessible_collections)
  end

  def accessible_artists
    return Artist.all if admin?
    Artist.joins(:works).where(works: accessible_works)
  end

  def accessible_users
    return User.where("1=1") if admin?
    return User.where("1=0") unless admin? || advisor?
    User.not_admin.left_outer_joins(:collections).where(collections_users: {collection_id: accessible_collections}).or(User.inactive)
  end

  def accessible_roles
    @accessible_roles ||= User::ROLES.select { |role| ability.can?("update_#{role}".to_sym, User) }
  end

  def role= new_role
    User::ROLES.each do |r|
      send("#{r}=", r.to_s == new_role.to_s) if methods.include?(r)
    end
    role
  end

  def activated?
    qkunst? || (collections.count > 0)
  end

  def registrator?
    qkunst? && (role == :qkunst)
  end

  def read_only?
    role == :read_only
  end

  def admin?
    read_attribute(:admin) && oauthable? && trusted_admin_domain?
  end
  alias_method :admin, :admin?

  def trusted_admin_domain?
    ADMIN_DOMAINS.include? domain
  end

  def enforce_oauth?
    admin?
  end

  def super_admin?
    admin? && read_attribute(:super_admin)
  end

  def oauthable?
    !!(oauth_subject && oauth_provider)
  end

  def generate_api_key!
    self.api_key = SecureRandom.hex(64)
  end

  def schedule_sync_stored_user_names
    UpdateCachedUserNamesWorker.perform_async(id) if saved_change_to_attribute?(:name)
  end

  def name
    read_attribute(:name) || email
  end

  def can_access_object? objekt = nil
    admin? || (objekt.methods.include?(:can_be_accessed_by_user?) && objekt.can_be_accessed_by_user?(self))
  end

  def can_filter_and_group?(grouping)
    return true if grouping == :themes
    return false if role == :read_only
    return false if [:techniques, :sources, :geoname_ids].include?(grouping) && facility_manager?
    true
  end

  def reset_filters!
    group_sorting_and_display = {
      group: filter_params[:group],
      sort: filter_params[:sort],
      display: filter_params[:display]
    }
    self.filter_params = {}.merge(group_sorting_and_display)
    save
  end

  def works_created
    Work.where(created_by_id: id)
  end

  def messages_sent
    Message.where(from_user_id: id)
  end

  def reset_all_roles
    ROLES.each do |role|
      unless role == :read_only # "default" role
        send("#{role}=", false)
      end
    end
  end

  private

  def serialize_collection_accessibility!
    to_store = collections.each_with_object({}) { |c, h| h[c.id] = c.name; }
    self.collection_accessibility_serialization = to_store
  end

  class << self
    def find_by_name(a)
      find_by_email(a)
    end

    def find_or_initialize_from_oauth_prisioned_data oauth_subject:, email:, oauth_provider:
      raise "Subject empty" if oauth_subject.blank?
      raise "Provider empty" if oauth_provider.blank?

      User.find_by(oauth_subject: oauth_subject, oauth_provider: oauth_provider) || User.find_by(email: email, oauth_subject: nil, oauth_provider: nil) || User.new(email: email, password: Devise.friendly_token[0, 48])
    end

    def from_omniauth_callback_data(data)
      if !data.is_a?(Users::OmniauthCallbackData) || !data.valid?
        raise ArgumentError.new("invalid omniauth data passed")
      else
        user = find_or_initialize_from_oauth_prisioned_data(oauth_subject: data.oauth_subject, oauth_provider: data.oauth_provider, email: data.email)
        user.oauth_provider = data.oauth_provider
        user.oauth_subject = data.oauth_subject
        user.email = data.email
        user.name = data.name
        user.qkunst = data.qkunst
        user.facility_manager = data.facility_manager
        user.domain = data.domain
        user.confirmed_at ||= Time.now if data.email_confirmed?
        user.raw_open_id_token = data.raw_open_id_token

        if OAuthGroupMapping.role_mappings_exists_for?(data.issuer)
          user.reset_all_roles
          new_role = ([:read_only, :facility_manager, :compliance] & OAuthGroupMapping.retrieve_roles(data))[0]
          user.role = new_role
        end

        if OAuthGroupMapping.collection_mappings_exists_for?(data.issuer)
          user.collection_ids = OAuthGroupMapping.retrieve_collection_ids(data)

          user.role = new_role
        end

        user.save

        user
      end
    end
  end
end
