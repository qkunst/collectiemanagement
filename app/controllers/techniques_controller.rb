class TechniquesController < ApplicationController
  include BaseController

  private

  def controlled_class
    Technique
  end
end
