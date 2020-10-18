# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_paper_trail

  ROLES = [:admin, :advisor, :compliance, :qkunst, :appraiser, :facility_manager, :read_only]

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :timeoutable

  store :collection_accessibility_serialization
  store :filter_params

  after_update :schedule_sync_stored_user_names

  has_and_belongs_to_many :collections

  scope :admin, -> { where(admin: true) }
  scope :not_admin, -> { where.not(admin: true) }
  scope :advisor, -> { where(advisor: true).where(admin: [false, nil]) }
  scope :appraiser, -> { where(appraiser: true).where(admin: [false, nil], advisor: [false, nil]) }
  scope :registrator, -> { where(qkunst: true).where(admin: [false, nil], appraiser: [false, nil], advisor: [false, nil]) }
  scope :qkunst, -> { where(qkunst: true) }
  scope :other, -> { where(qkunst: [false, nil], admin: [false, nil], appraiser: [false, nil], advisor: [false, nil]) }
  scope :has_collections, -> { joins(:collections).uniq }
  scope :receive_mails, -> { where(receive_mails: true) }
  scope :inactive, -> { other.left_outer_joins(:collections).where(collections_users: {id: nil}) }

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
    @accessible_collections ||= admin? ? Collection.all : collections.expand_with_child_collections
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
    Artist.joins(:works).where(works: {id: accessible_works})
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

  private

  def serialize_collection_accessibility!
    to_store = collections.each_with_object({}) { |c, h| h[c.id] = c.name; }
    self.collection_accessibility_serialization = to_store
  end

  class << self
    def find_by_name(a)
      find_by_email(a)
    end
  end
end
