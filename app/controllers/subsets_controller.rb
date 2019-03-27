# frozen_string_literal: true

class SubsetsController < ApplicationController
  include BaseController

  private

  def controlled_class
    Subset
  end
end
