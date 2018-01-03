class Cluster < ApplicationRecord
  has_many :works
  belongs_to :collection, optional: true
  validates_uniqueness_of :name, scope: :collection_id

  include NameId

  class << self
    def remove_all_without_works
      Cluster.joins("LEFT JOIN works ON works.cluster_id = clusters.id").uniq.where("works.id IS NULL").destroy_all
    end

  end
end
