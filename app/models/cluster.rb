# frozen_string_literal: true

# == Schema Information
#
# Table name: clusters
#
#  id            :bigint           not null, primary key
#  description   :text
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  collection_id :bigint
#
class Cluster < ApplicationRecord
  include CollectionOwnable
  include NameId

  has_many :works
  before_destroy :remove_cluster_id_at_works
  after_save :reindex_works!

  scope :not_hidden, -> { where("1=1") }

  def remove_cluster_id_at_works
    c_id = id
    Work.where(cluster_id: c_id).update_all(cluster_id: nil)
  end

  private

  def reindex_works!
    works.reindex_async!
  end

  class << self
    def remove_all_without_works
      Cluster.joins("LEFT JOIN works ON works.cluster_id = clusters.id").distinct.where("works.id IS NULL").destroy_all
    end

    def remove_cluster_id_where_cluster_is_removed!
      ids = Cluster.ids
      Work.where.not(cluster_id: ids).update_all(cluster_id: nil)
    end
  end
end
