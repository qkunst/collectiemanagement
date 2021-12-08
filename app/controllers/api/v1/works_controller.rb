# frozen_string_literal: true

class Api::V1::WorksController < Api::V1::ApiController
  before_action :authenticate_activated_user!

  def index
    @collection = @user.accessible_collections.find(params[:collection_id])
    api_authorize! :read_api, @collection
    @works = @collection.works_including_child_works
    @works = @works.limit(params[:limit].to_i) if params[:limit]
    @works = @works.all
  end

  def show
    @collection = @user.accessible_collections.find(params[:collection_id])
    api_authorize! :read_api, @collection
    @work = @collection.works_including_child_works.find(params[:id])
  end
end
