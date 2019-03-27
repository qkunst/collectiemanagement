# frozen_string_literal: true

class StylesController < ApplicationController
  include BaseController

  private

  def controlled_class
    Style
  end
end
