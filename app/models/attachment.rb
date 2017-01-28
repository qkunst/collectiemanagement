class Attachment < ApplicationRecord
  belongs_to :attache, polymorphic: true

  validates_presence_of :file

  scope :for_me, ->(user){ where("")}
  scope :for_me, ->(user){ user.admin? ? where("") : where(arel_table[:visibility].matches_any(user.roles.collect{|role| "%#{role}%"}))}

  mount_uploader :file, BasicFileUploader

  def visibility
    read_attribute(:visibility).to_s.split(",")
  end

  def visibility= values
    write_attribute(:visibility, values.delete_if{|a| a.nil? or a.empty?}.join(","))
  end

  def file_name
    name? ? name : read_attribute(:file)
  end

end
