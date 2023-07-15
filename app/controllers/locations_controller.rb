# frozen_string_literal: true

class LocationsController < ApplicationController
  include BaseController

  private

  def controlled_class
    Location
  end

  def white_listed_params
    params.require(singularized_name.to_sym).permit(:name, :address, :order, :hide, :collection_id)
  end
end
