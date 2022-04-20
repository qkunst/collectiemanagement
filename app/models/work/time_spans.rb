# frozen_string_literal: true

module Work::TimeSpans
  extend ActiveSupport::Concern

  included do
    def available?
      !(current_active_time_span || removed_from_collection?)
    end

    def availability_status
      @availability_status ||= if available?
        :available
      elsif removed_from_collection_at || current_active_time_span&.classification == "purchase"
        :sold
      elsif current_active_time_span&.classification == "rental_outgoing"
        :lent
      end
    end

    def current_active_time_span
      @current_active_time_span ||= time_spans.select(&:current_and_active?).last
    end


  end
end