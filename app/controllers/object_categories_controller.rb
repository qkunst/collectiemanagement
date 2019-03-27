# frozen_string_literal: true

class ObjectCategoriesController < ApplicationController
  include BaseController

  private

  def controlled_class
    ObjectCategory
  end
end
