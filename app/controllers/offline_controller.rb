# frozen_string_literal: true

class OfflineController < ApplicationController
  skip_before_action :set_paper_trail_whodunnit

  def work_form
    @work = Work.new
    @collection = Collection.new(id: -1, base: true)
  end

  def offline
  end

  def collection
  end
end
