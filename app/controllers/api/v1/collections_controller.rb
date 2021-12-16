class Api::V1::CollectionsController < Api::V1::ApiController
  before_action :authenticate_activated_user!
  def index
    @collections = params[:include_children] == "true" ? @user.accessible_collections : @user.collections
  end
end