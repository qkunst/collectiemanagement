class Api::V1::WorksController < Api::V1::ApiController
  before_action :authenticate_activated_user!

  def index
    @collection = @user.accessible_collections.find(params[:collection_id])
    @works = @collection.works_including_child_works.all
  end

  def show
    @collection = @user.accessible_collections.find(params[:collection_id])
    @work = @collection.works_including_child_works.find(params[:id])
  end
end
