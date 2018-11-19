class OwnersController < ApplicationController
  include BaseController

  def index
    @owners = @collection.available_owners
  end

  private


  def controlled_class
    Owner
  end
end
