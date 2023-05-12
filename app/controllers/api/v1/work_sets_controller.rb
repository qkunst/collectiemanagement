# frozen_string_literal: true

class Api::V1::WorkSetsController < Api::V1::ApiController
  before_action :authenticate_activated_user!

  def show
    @work_set = current_api_user.accessible_work_sets.find_by!(uuid: params[:id])
  end
end
