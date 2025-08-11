# frozen_string_literal: true

class DamageTypesController < ApplicationController
  include BaseController

  private

  def controlled_class
    DamageType
  end

  def base_view? = true
end
