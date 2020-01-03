# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_paper_trail

  ROLES = [:admin, :advisor, :compliance, :qkunst , :appraiser, :facility_manager, :read_only]

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable

  store :collection_accessibility_serialization
  store :filter_params

  after_update :schedule_sync_stored_user_names

  has_and_belongs_to_many :collections

  scope :admin, ->{ where(admin: true) }
  scope :not_admin, ->{ where.not(admin: true) }
  scope :advisor, ->{ where(advisor: true).where(admin: [false, nil]) }
  scope :appraiser, ->{ where(appraiser: true).where(admin: [false, nil], advisor: [false, nil]) }
  scope :qkunst, ->{ where(qkunst: true).where(admin: [false, nil], appraiser: [false, nil], advisor: [false, nil]) }
  scope :other, ->{ where(qkunst: [false,nil], admin: [false, nil], appraiser: [false, nil], advisor: [false, nil]) }
  scope :has_collections, ->{ joins(:collections).uniq }
  scope :receive_mails, ->{ where(receive_mails: true)}
  scope :inactive, -> { other.left_outer_joins(:collections).where(collections_users: {id: nil})}

  before_save :serialize_collection_accessibility!

  def qkunst?
    read_attribute(:qkunst) or admin? or appraiser? or advisor?
  end

  def role
    roles.first
  end

  def roles
    rv = User::ROLES.collect do |r|
      r if self.methods.include?(r) and self.send(r)
    end
    rv = (rv.compact + [:read_only])
    rv
  end

  def ability
    @ability ||= Ability.new(self)
  end

  def admin_with_favorites?
    collections.count > 0
  end

  def accessible_collections
    return Collection.all if admin?
    collections.expand_with_child_collections
  end

  def accessible_works
    return Work.all if admin?
    Work.where(collection_id: accessible_collections)
  end

  def accessible_users
    return User.where("1=1") if admin?
    return User.where("1=0") if !(admin? or advisor?)
    return User.not_admin.left_outer_joins(:collections).where(collections_users: {collection_id: accessible_collections}).or(User.inactive)
  end

  def accessible_roles
    admin? ? User::ROLES : User::ROLES - [:admin]
  end


  def role= new_role
    User::ROLES.each do |r|
      self.send("#{r}=", r.to_s == new_role.to_s) if self.methods.include?(r)
    end
    return new_role
  end

  def activated?
    qkunst? or collections.count > 0
  end

  def registrator?
    qkunst? and (role == :qkunst)
  end

  def generate_api_key!
    self.api_key = SecureRandom.hex(64)
  end

  def schedule_sync_stored_user_names
    UpdateCachedUserNamesWorker.perform_async(self.id) if saved_change_to_attribute?(:name)
  end

  def name
    read_attribute(:name) || email
  end

  def can_access_message? message=nil
    admin? or (message &&
      message.from_user == self ||
      (message.conversation_start_message && message.conversation_start_message.from_user == self) ||
      (message.conversation_start_message && message.conversation_start_message.to_user == self) ||
      (message.subject_object && can_access_object?(message.subject_object))
    )
  end

  def can_access_object? objekt=nil
    admin? or (objekt.methods.include?(:can_be_accessed_by_user?) and objekt.can_be_accessed_by_user?(self))
  end

  def can_edit_most_of_work?
    qkunst? or appraiser?
  end

  def can_edit_photos?
    qkunst?
  end

  def can_filter_and_group?( grouping )
    return true if grouping == :themes
    return false if read_only?
    return false if [:techniques, :sources, :geoname_ids].include?(grouping) and facility_manager?
    return true
  end

  def read_only?
    role == :read_only
  end

  def reset_filters!
    group_sorting_and_display = {
      group: self.filter_params[:group],
      sort: self.filter_params[:sort],
      display: self.filter_params[:display]
    }
    self.filter_params = {}.merge(group_sorting_and_display)
    self.save
  end

  def works_created
    Work.where(created_by_id: self.id)
  end

  private

  def serialize_collection_accessibility!
    to_store = self.collections.inject({}){|h, c| h[c.id]=c.name; h }
    self.collection_accessibility_serialization = to_store
  end

  class << self
    def find_by_name(a)
      find_by_email(a)
    end
  end
end
