# frozen_string_literal: true

# == Schema Information
#
# Table name: attachments
#
#  id            :bigint           not null, primary key
#  file          :string
#  name          :string
#  visibility    :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  collection_id :bigint
#
class Attachment < ApplicationRecord
  belongs_to :collection
  has_and_belongs_to_many :works
  has_and_belongs_to_many :artists

  validates_presence_of :file

  scope :for_roles, ->(roles) { (roles.include?(:admin) || roles.include?(:advisor)) ? where("1 = 1") : where(arel_table[:visibility].matches_any(roles.collect { |role| "%#{role}%" })) }
  scope :for_role, ->(role) { for_roles([role]) }
  scope :for_me, ->(user) { for_roles(user.roles).where(collection_id: user.accessible_collection_ids) }
  scope :without_works, -> { left_outer_joins(:works).where(works: {id: nil}) }
  scope :without_artists, -> { left_outer_joins(:artists).where(artists: {id: nil}) }

  mount_uploader :file, BasicFileUploader

  def visibility
    read_attribute(:visibility).to_s.split(",")
  end

  def visibility= values
    write_attribute(:visibility, values.delete_if { |a| a.nil? || a.empty? }.join(","))
  end

  def append_works= works
    self.works = Work.where(id: (works.pluck(:id) + self.works.pluck(:id))).distinct
  end

  def append_artists= artists
    self.artists = Artist.where(id: (artists.pluck(:id) + self.artists.pluck(:id))).distinct
  end

  def file_name
    name? ? name : read_attribute(:file)
  end

  def extension
    read_attribute(:file).split(".").last
  end

  def export_file_name
    rv = file_name.downcase.gsub(/\s+/, "_").gsub(/[\#%&{}\\<>*?\/$!'":@+`|=,]/, "")
    rv.end_with?(".#{extension}") ? rv : "#{rv}.#{extension}"
  end
end
