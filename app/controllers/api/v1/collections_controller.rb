class Api::V1::CollectionsController < Api::V1::ApiController
  before_action :authenticate_activated_user!
  def index
    @collections = params[:include_children] == "true" ? @user.accessible_collections.not_root : Collection.for_user(@user).not_root.all
  end

  def show
    @collection =  @user.accessible_collections.find(params[:id])
  end
end