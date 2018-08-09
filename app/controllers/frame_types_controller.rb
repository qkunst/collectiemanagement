class FrameTypesController < ApplicationController
  include BaseController

  private

  def controlled_class
    FrameType
  end
end
