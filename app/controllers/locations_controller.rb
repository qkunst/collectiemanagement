# frozen_string_literal: true

class LocationsController < ApplicationController
  include BaseController

  private

  def controlled_class
    Location
  end
end
