# frozen_string_literal: true

class WorkStatusesController < ApplicationController
  include BaseController

  private

  def controlled_class
    WorkStatus
  end
end
