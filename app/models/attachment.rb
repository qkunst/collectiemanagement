class Attachment < ApplicationRecord
  belongs_to :attache, polymorphic: true

  validates_presence_of :file

  scope :for_me, ->(user){ where("")}

  mount_uploader :file, BasicFileUploader

  def visibility
    read_attribute(:visibility).to_s.split(",")
  end

  def visibility= values
    write_attribute(:visibility, values.join(","))
  end

end
