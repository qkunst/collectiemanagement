class Api::V1::WorksController < Api::V1::ApiController
  def index

    @works = Collection.find(params[:collection_id]).works
  end
end
