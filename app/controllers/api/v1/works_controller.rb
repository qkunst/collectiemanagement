class Api::V1::WorksController < Api::V1::ApiController
  def index
    @collection = Collection.find(params[:collection_id])
    return not_authorized unless (@user.admin? or @collection.users.include?(@user))

    @works = @collection.works
  end
end
