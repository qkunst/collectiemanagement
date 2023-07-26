# frozen_string_literal: true

class OfflineController < ApplicationController
  def work_form
    @work = Work.new
    @collection = Collection.new(id: -1, base: true)
  end

  def offline
  end

  def collection
  end
end
