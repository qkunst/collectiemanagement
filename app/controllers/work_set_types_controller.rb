# frozen_string_literal: true

class WorkSetTypesController < ApplicationController
  include BaseController

  private

  def controlled_class
    WorkSetType
  end

  def white_listed_params
    params.require(singularized_name.to_sym).permit(:name, :hide, :count_as_one, :appraise_as_one)
  end
end
