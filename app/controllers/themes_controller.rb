class ThemesController < ApplicationController
  include BaseController

  def index
    @themes = Theme.all
    if @collection
      render 'collections/themes.html.erb'
    else
      @collections = Collection.without_parent.all
      render 'index.html.erb'
    end
  end

  private

  def controlled_class
    Theme
  end
end
