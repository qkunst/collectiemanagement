# frozen_string_literal: true

class WorkStatusesController < ApplicationController
  include BaseController

  private

  def controlled_class
    WorkStatus
  end

  def white_listed_params
    params.require(singularized_name.to_sym).permit(:name, :hide, :set_work_as_removed_from_collection)
  end
end
