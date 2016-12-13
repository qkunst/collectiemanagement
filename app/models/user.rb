class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  store :filter_params
  has_and_belongs_to_many :collections

  scope :admin, ->{ where(admin: true) }
  scope :qkunst, ->{ where(qkunst: true).where(admin: [false, nil]) }
  scope :other, ->{ where(qkunst: [false,nil]).where(admin: [false, nil]) }
  scope :has_collections, ->{ joins(:collections).uniq }
  scope :receive_mails, ->{ where(receive_mails: true)}

  def qkunst?
    read_attribute(:qkunst) or admin?
  end

  def role
    User.roles.each do |r|
      return r if self.methods.include?(r) and self.send(r)
    end
    return :read_only
  end

  def role= new_role
    User.roles.each do |r|
      self.send("#{r}=", r.to_s == new_role.to_s) if self.methods.include?(r)
    end
    return new_role
  end

  def name
    email
  end

  def activated?
    qkunst? or collections.count > 0
  end

  def can_access_report?
    qkunst? or facility_manager?
  end

  def can_access_location_info?
    qkunst? or facility_manager?
  end

  def can_quickedit_location_info?
    qkunst? or facility_manager?
  end

  def can_receive_messages?
    admin? or facility_manager?
  end

  def can_write_messages?
    admin? or facility_manager?
  end

  def can_edit_message? message=nil
    admin? or (message && message.from_user == self && message.replies.count == 0 && message.unread)
  end

  def generate_api_key!
    self.api_key = SecureRandom.hex(64)
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
    return true if admin?
    return false if objekt == nil
    if objekt.is_a? Collection
      return objekt.can_be_accessed_by_user(self)
    elsif objekt.is_a? Work
      return objekt.collection.can_be_accessed_by_user(self)
    end
    return false
  end

  def can_see_details?
    qkunst? or facility_manager?
  end

  def can_access_valuation?
    admin? or facility_manager?
  end

  def can_access_extended_report?
    qkunst?
  end

  def can_download?
    admin? or facility_manager?
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

  class << self
    def roles
      [:admin, :qkunst, :read_only, :facility_manager]
    end
    def find_by_name(a)
      find_by_email(a)
    end
  end
end
