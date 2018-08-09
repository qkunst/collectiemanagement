class PlaceabilitiesController < ApplicationController
  include BaseController

  private

  def controlled_class
    Placeability
  end
end
