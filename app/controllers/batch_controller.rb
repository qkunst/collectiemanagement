# frozen_string_literal: true

class BatchForm
  UPDATE_STRATEGIES = [:replace, :append]

  include ActiveModel::Conversion

  attr_accessor :location, :location_floor, :location_detail
  attr_accessor :update_location, :update_location_floor, :update_location_detail
  attr_accessor :update_location_strategy, :update_location_floor_strategy, :update_location_detail_strategy

  def model_name
    # act like a model
    Work.new.model_name
  end
end

class BatchController < ApplicationController
  before_action :set_collection
  before_action :set_works_by_numbers

  include BatchMethods

  def show
  end

  def work_params

  end

  def set_works_by_numbers
    work_numbers = params[:work_numbers_return_separated].to_s.split(/\n/).map(&:strip).select(&:present?)
    @form = BatchForm.new
    @works = @collection.works_including_child_works.has_number(work_numbers)
  end
end
