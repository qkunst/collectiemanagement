# frozen_string_literal: true

class FrameDamageTypesController < ApplicationController
  include BaseController

  private

  def controlled_class
    FrameDamageType
  end
end
