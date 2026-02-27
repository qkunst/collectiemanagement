# frozen_string_literal: true

# == Schema Information
#
# Table name: attachments
#
#  id            :integer          not null, primary key
#  name          :string
#  file          :string
#  visibility    :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  collection_id :integer
#

class Attachment < ApplicationRecord
  belongs_to :collection
  has_and_belongs_to_many :works
  has_and_belongs_to_many :artists

  validates :file, presence: true

  scope :for_roles, ->(roles) { (roles.include?(:admin) || roles.include?(:advisor)) ? where("1 = 1") : where(arel_table[:visibility].matches_any(roles.collect { |role| "%#{role}%" })) }
  scope :for_role, ->(role) { for_roles([role]) }
  scope :for_me, ->(user) { for_roles(user.roles).where(collection_id: user.accessible_collection_ids) }
  scope :without_works, -> { where.missing(:works) }
  scope :without_artists, -> { where.missing(:artists) }

  mount_uploader :file, BasicFileUploader

  def visibility
    read_attribute(:visibility).to_s.split(",")
  end

  def visibility= values
    write_attribute(:visibility, values.compact_blank!.join(","))
  end

  def append_works= works
    self.works = Work.where(id: (works.pluck(:id) + self.works.pluck(:id))).distinct
  end

  def append_artists= artists
    self.artists = Artist.where(id: (artists.pluck(:id) + self.artists.pluck(:id))).distinct
  end

  def file_name
    name? ? name : self[:file]
  end

  def extension
    self[:file].split(".").last
  end

  def export_file_name
    rv = file_name.downcase.gsub(/\s+/, "_").gsub(/[\#%&{}\\<>*?\/$!'":@+`|=,]/, "")
    rv.end_with?(".#{extension}") ? rv : "#{rv}.#{extension}"
  end
end
