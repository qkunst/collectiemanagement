# frozen_string_literal: true

class InvolvementsController < ApplicationController
  include BaseController

  private

  def controlled_class
    Involvement
  end

  def white_listed_params
    params.require(:involvement).permit(:name, :place, :place_geoname_id)
  end
end
