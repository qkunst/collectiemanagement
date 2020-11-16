# frozen_string_literal: true

class BalanceCategoriesController < ApplicationController
  include BaseController

  private

  def controlled_class
    BalanceCategory
  end
end
