# frozen_string_literal: true

module Work::TimeSpans
  extend ActiveSupport::Concern

  included do
    def available?
      !(removed_from_collection? || current_active_time_span)
    end

    def availability_status
      @availability_status ||= if removed_from_collection_at || current_active_time_span&.classification == "purchase"
        :sold
      elsif available? && (for_purchase || for_rent)
        :available
      elsif available? && !(for_purchase || for_rent)
        :available_not_for_rent_or_purchase
      elsif current_active_time_span&.status == "reservation"
        :reserved
      elsif current_active_time_span&.classification == "rental_outgoing"
        :lent
      end
    end

    def current_active_time_span
      @current_active_time_span ||= (time_spans.reverse.find(&:current_and_active?) || time_spans.reverse.find(&:current_and_active_or_reserved?))
    end

    def last_active_time_span
      @last_active_time_span ||= time_spans.max_by(&:created_at)
    end

    def currently_relevant_time_span
      (availability_status == :sold) ? last_active_time_span : current_active_time_span
    end
  end
end
