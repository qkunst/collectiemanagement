class StylesController < ApplicationController
  include BaseController

  private

  def controlled_class
    Style
  end
end
