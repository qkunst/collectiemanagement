# frozen_string_literal: true

class MediaController < ApplicationController
  include BaseController

  private

  def controlled_class
    Medium
  end

  def base_view? = true
end
