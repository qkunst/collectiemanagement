# frozen_string_literal: true

# == Schema Information
#
# Table name: messages
#
#  id                               :bigint           not null, primary key
#  actioned_upon_by_qkunst_admin_at :datetime
#  attachment                       :string
#  from_user_name                   :string
#  image                            :string
#  just_a_note                      :boolean
#  message                          :text
#  qkunst_private                   :boolean
#  subject                          :string
#  subject_object_type              :string
#  subject_url                      :text
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  conversation_start_message_id    :bigint
#  from_user_id                     :bigint
#  in_reply_to_message_id           :bigint
#  reminder_id                      :bigint
#  subject_object_id                :bigint
#  to_user_id                       :bigint
#
class Message < ApplicationRecord
  include Rails.application.routes.url_helpers

  mount_uploader :attachment, BasicFileUploader
  mount_uploader :image, PictureUploader

  has_many :replies, class_name: "Message", foreign_key: :in_reply_to_message_id
  has_many :conversation, class_name: "Message", foreign_key: :conversation_start_message_id

  # validates_presence_of :subject
  # validates_presence_of :message

  belongs_to :subject_object, polymorphic: true, optional: true
  belongs_to :from_user, class_name: "User", optional: true
  belongs_to :to_user, class_name: "User", optional: true
  belongs_to :in_reply_to_message, class_name: "Message", optional: true
  belongs_to :conversation_start_message, class_name: "Message", optional: true
  belongs_to :reminder, optional: true

  scope :order_by_creation_date, -> { order(:created_at) }
  scope :order_by_reverse_creation_date, -> { order(created_at: :desc) }
  scope :conversation_starters, -> { where("messages.conversation_start_message_id IS NULL or messages.conversation_start_message_id = messages.id") }
  scope :thread_can_be_accessed_by_user, ->(user) do
    if user.admin?
      where("1=1")
    elsif user.advisor? || user.compliance? || user.facility_manager?
      where("messages.from_user_id = ? OR messages.to_user_id = ? OR (SELECT COUNT(messages_a.id) FROM messages AS messages_a WHERE messages_a.id = messages.conversation_start_message_id AND (messages_a.from_user_id = ? OR messages_a.to_user_id = ?)) = 1 OR (messages.subject_object_id IN (?) AND messages.subject_object_type = 'Work') OR (messages.subject_object_id IN (?) AND messages.subject_object_type = 'Collection')", user.id, user.id, user.id, user.id, user.accessible_works.map(&:id), user.accessible_collections.map(&:id))
    else
      where("messages.from_user_id = ? OR messages.to_user_id = ? OR (SELECT COUNT(messages_a.id) FROM messages AS messages_a WHERE messages_a.id = messages.conversation_start_message_id AND (messages_a.from_user_id = ? OR messages_a.to_user_id = ?)) = 1", user.id, user.id, user.id, user.id)
    end
  end
  scope :not_qkunst_private, -> { where(qkunst_private: [nil, false]) }
  scope :for, ->(subject_object) { where(subject_object: subject_object) }
  scope :sent_at_date, ->(date) { where("messages.created_at >= ? AND messages.created_at <= ?", date.to_time.beginning_of_day, date.to_time.end_of_day) }
  scope :collections, ->(collections) do
    collections = Collection.where(id: collections).expand_with_child_collections
    joins("LEFT OUTER JOIN works ON messages.subject_object_id = works.id AND messages.subject_object_type = 'Work'").where("(messages.subject_object_type = 'Collection' AND messages.subject_object_id IN (?)) OR (messages.subject_object_type = 'Work' AND works.collection_id IN (?))", collections.map(&:id), collections.map(&:id))
  end
  scope :limit_age_to, ->(age_limitation = 1.year) { where("messages.created_at > ?", age_limitation.ago) }
  scope :human_messages, -> { where.not(from_user_id: nil) }
  scope :system_messages, -> { where(from_user_id: nil) }

  before_create :set_conversation_start_message
  before_save :set_from_user_name!

  after_create :send_notification
  after_create :set_previous_message_as_actioned_upon_by_qkunst_admin_when_replied_to

  time_as_boolean :actioned_upon_by_qkunst_admin

  def from_user_name_without_email
    from_user_name.to_s.split("@")[0].to_s.capitalize
  end

  def from_user?(user)
    from_user == user
  end

  def read(user = nil)
    actioned_upon_by_qkunst_admin? || (user && from_user?(user)) || (user && !user.qkunst? && from_user && from_user.qkunst?)
  end

  def unread(user = nil)
    !read(user)
  end

  def unread_messages_in_thread(user = nil)
    return @unread_messages_in_thread unless @unread_messages_in_thread.nil?
    unreads = (conversation.collect { |a| a.unread(user) } + [unread(user)]).uniq
    @unread_messages_in_thread = !((unreads.count == 1) && (unreads.first == false))
  end

  def subject_rendered
    (subject.nil? || subject.empty?) ? "[Geen onderwerp]" : subject
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
    users = conversation_users.all
    users += User.admin.receive_mails.all unless to_user
    users += [to_user]
    users -= [from_user]
    users.compact!

    users_count = users.count

    if qkunst_private?
      users.delete_if { |user| !user.qkunst? }
      if users == [] && users_count > 0
        users += User.admin.receive_mails.all
      end
    end
    users.compact.uniq
  end

  def from_qkunst?
    from_user&.qkunst?
  end

  def auto_subject?
    subject_url || subject_object
  end

  def conversation_starter?
    conversation_start_message_id.nil? || (conversation_start_message_id == id)
  end

  def set_conversation_start_message
    if in_reply_to_message_id
      prev = Message.find(in_reply_to_message_id)
      self.conversation_start_message = prev.conversation_start_message || prev
    end
  end

  def send_notification
    notifyable_users.each do |user|
      MessageMailer.new_message(user, self).deliver_now
    end
  end

  def actioned_upon_by_qkunst_admin= bool
    self.actioned_upon_by_qkunst_admin_at ||= Time.now
    if conversation_start_message.nil?
      time = Time.now
      conversation.each do |conversation_message|
        conversation_message.actioned_upon_by_qkunst_admin_at ||= time
        conversation_message.save
      end
    end
  end

  private

  def set_from_user_name!
    if from_user
      self.from_user_name = from_user.name
    end
  end

  def set_previous_message_as_actioned_upon_by_qkunst_admin_when_replied_to
    if conversation_start_message
      conversation_start_message.actioned_upon_by_qkunst_admin! if from_user&.qkunst?
    end
  end
end
