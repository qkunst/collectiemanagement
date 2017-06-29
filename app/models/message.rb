class Message < ApplicationRecord
  include Rails.application.routes.url_helpers

  mount_uploader :image, PictureUploader
  before_create :set_conversation_start_message

  has_many :replies, class_name: 'Message', foreign_key: :in_reply_to_message_id
  has_many :conversation, class_name: 'Message', foreign_key: :conversation_start_message_id

  validates_presence_of :subject
  validates_presence_of :message

  belongs_to :subject_object, polymorphic: true
  belongs_to :from_user, class_name: 'User'
  belongs_to :to_user, class_name: 'User'
  belongs_to :in_reply_to_message, class_name: 'Message'
  belongs_to :conversation_start_message, class_name: 'Message'
  belongs_to :reminder

  scope :order_by_creation_date, -> {order(:created_at)}
  scope :order_by_reverse_creation_date, -> {order(created_at: :desc)}
  scope :conversation_starters, -> {where("messages.conversation_start_message_id IS NULL or messages.conversation_start_message_id = messages.id")}
  scope :thread_can_be_accessed_by_user, ->(user) { where("messages.from_user_id = ? OR messages.to_user_id = ? OR (SELECT COUNT(messages_a.id) FROM messages AS messages_a WHERE messages_a.id = messages.conversation_start_message_id AND (messages_a.from_user_id = ? OR messages_a.to_user_id = ?)) = 1", user.id,user.id,user.id,user.id)}
  scope :not_qkunst_private, -> {where(qkunst_private: [nil, false])}
  scope :for, ->(subject_object) { where(subject_object: subject_object )}
  scope :sent_at_date, ->(date) {where("messages.created_at >= ? AND messages.created_at <= ?", date.to_time.beginning_of_day, date.to_time.end_of_day)}

  before_save :set_from_user_name!
  after_create :send_notification

  def set_from_user_name!
    self.from_user_name = (from_user ? from_user.name.to_s : "")
  end

  def from_user?(user)
    from_user == user
  end

  def read(user=nil)
    !actioned_upon_by_qkunst_admin_at.nil? or (user and from_user?(user)) or (user and !user.qkunst? and from_user and from_user.qkunst?)
  end

  def unread(user=nil)
    !read(user)
  end

  def unread_messages_in_thread(user=nil)
    return @unread_messages_in_thread if (@unread_messages_in_thread != nil)
    unreads = (conversation.collect{|a| a.unread(user)}+[self.unread(user)]).uniq
    @unread_messages_in_thread = !(unreads.count == 1 and unreads.first == false)
  end

  def actioned_upon_by_qkunst_admin!
    self.actioned_upon_by_qkunst_admin_at = Time.now
    self.save
  end

  def url_options
    default_url_options.merge({only_path: true})
  end

  def subject_url
    own_value = read_attribute(:subject_url)
    return own_value if own_value
    redirect_to_obj = nil

    if subject_object.is_a? Collection
      redirect_to_obj = subject_object
    elsif subject_object.is_a? Work
      redirect_to_obj = [subject_object.collection, subject_object]
    end
    if redirect_to_obj

      url_for(redirect_to_obj)
    end
  end
  def redirect_to_object

  end

  def conversation_users
    start_message = conversation_start_message || self
    users = [start_message.from_user_id, start_message.to_user_id]
    start_message.conversation.each do |conversation_message|
      users << conversation_message.from_user_id
      users << conversation_message.to_user_id
    end
    User.where(id: users.compact.uniq)
  end

  def notifyable_users
    users = conversation_users.receive_mails.all
    users += User.admin.receive_mails.all
    users += [self.to_user]
    users -= [self.from_user]
    users.compact!
    if self.qkunst_private?
      users.delete_if{|user| !user.qkunst? }
    end
    users.compact.uniq
  end

  def from_qkunst?
    from_user.qkunst? if from_user
  end

  def auto_subject?
    subject_url or subject_object
  end

  def conversation_starter?
    conversation_start_message_id.nil? or conversation_start_message_id == self.id
  end

  def set_conversation_start_message
    if in_reply_to_message_id
      prev = Message.find(in_reply_to_message_id)
      self.conversation_start_message = prev.conversation_start_message ? prev.conversation_start_message : prev
    end
  end

  def send_notification
    notifyable_users.each do | user |
      MessageMailer.new_message(user, self).deliver_now
    end
  end
end
