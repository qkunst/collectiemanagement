class Cluster < ApplicationRecord
  has_many :works
  belongs_to :collection, optional: true
  validates_presence_of :name
  validates_uniqueness_of :name, scope: :collection_id
  before_destroy :remove_cluster_id_at_works

  include NameId

  def remove_cluster_id_at_works
    c_id = self.id
    Work.where(cluster_id: c_id).update_all(cluster_id: nil)
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
