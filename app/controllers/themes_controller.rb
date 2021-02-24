# frozen_string_literal: true

class ThemesController < ApplicationController
  include BaseController

  def index
    @themes = Theme.all
    if @collection
      render "collections/themes"
    else
      @collections = Collection.without_parent.all
      render "index"
    end
  end

  private

  def controlled_class
    Theme
  end
end
