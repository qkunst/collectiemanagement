class Cluster < ApplicationRecord
  has_many :works
  belongs_to :collection

  include NameId

  class << self
    def remove_all_without_works
      Cluster.joins("LEFT JOIN works ON works.cluster_id = clusters.id").uniq.where("works.id IS NULL").destroy_all
    end

  end
end
