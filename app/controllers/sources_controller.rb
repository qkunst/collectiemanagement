# frozen_string_literal: true

class SourcesController < ApplicationController
  include BaseController

  private

  def controlled_class
    Source
  end
end
