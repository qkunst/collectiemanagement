# frozen_string_literal: true

class ConditionsController < ApplicationController
  include BaseController

  private

  def controlled_class
    Condition
  end
end
