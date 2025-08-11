# frozen_string_literal: true

class LogisticalPeculiaritiesController < ApplicationController
  include BaseController

  private

  def controlled_class
    LogisticalPeculiarity
  end

  def base_view? = true
end
