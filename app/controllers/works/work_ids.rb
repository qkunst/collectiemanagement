# frozen_string_literal: true

module Works::WorkIds
  extend ActiveSupport::Concern

  included do
    def works_to_work_ids_hash
      IdsHash.store(@works.map(&:id)).hashed
    end

    def set_works_by_work_ids_or_work_ids_hash
      if params[:works] || params[:work_ids]
        work_ids = (params[:works] || params[:work_ids]).map { |w| w.to_i }
        @works = current_user.accessible_works.where(id: work_ids)
      elsif params[:work_ids_hash]
        work_ids = IdsHash.find_by_hashed(params[:work_ids_hash]).ids
        @works = current_user.accessible_works.where(id: work_ids)
      end
    end
  end
end
