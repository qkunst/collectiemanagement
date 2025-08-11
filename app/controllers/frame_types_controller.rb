# frozen_string_literal: true

class FrameTypesController < ApplicationController
  include BaseController

  private

  def controlled_class
    FrameType
  end

  def base_view? = true
end
