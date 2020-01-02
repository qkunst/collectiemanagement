# frozen_string_literal: true

class MobilesController < ApplicationController
  before_action :set_collection
  before_action :set_works_by_numbers
  include BatchMethods

  def show
  end

  def set_works_by_numbers
    work_numbers = params[:work_numbers_return_separated].to_s.split(/\n/).map(&:strip).select(&:present?)
    @works = @collection.works_including_child_works.has_number(work_numbers)
  end
end
