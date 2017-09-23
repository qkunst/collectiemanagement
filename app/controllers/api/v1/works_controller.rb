class Api::V1::WorksController < Api::V1::ApiController
  def index
    begin
      @collection = @user.accessible_collections.find(params[:collection_id])
    rescue
      return not_authorized
    end
    @works = @collection.works_including_child_works.all
  end

  def show
    begin
      @collection = @user.accessible_collections.find(params[:collection_id])
    rescue
      return not_authorized
    end
    @work = @collection.works_including_child_works.find(params[:id])
  end
end
