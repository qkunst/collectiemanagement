# frozen_string_literal: true

class OwnersController < ApplicationController
  include BaseController

  def index
    @owners = @collection.available_owners
  end

  private

  def controlled_class
    Owner
  end

  def white_listed_params
    params.require(singularized_name.to_sym).permit(:name, :description, :creating_artist, :hide, :collection_id)
  end
end
