# frozen_string_literal: true

class ClustersController < ApplicationController
  include BaseController

  # GET /clusters
  # GET /clusters.json
  def index
    @clusters = @collection.clusters.all
    @clusters_in_child_collections = Cluster.where(collection_id: (@collection.child_collections_flattened.to_a - [@collection])).includes(:collection).all
  end

  private

  def controlled_class
    Cluster
  end
end
