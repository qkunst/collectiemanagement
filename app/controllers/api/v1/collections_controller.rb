class Api::V1::CollectionsController < Api::V1::ApiController
  before_action :authenticate_activated_user!
  def index
    @collections = @user.collections
  end
end