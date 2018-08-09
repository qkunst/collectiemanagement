class OwnersController < ApplicationController
  include BaseController

  def index
    @owners = @collection.owners_including_parent_owners
  end

  private


  def controlled_class
    Owner
  end
end
