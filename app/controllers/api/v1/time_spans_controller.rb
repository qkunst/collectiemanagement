# frozen_string_literal: true

class Api::V1::TimeSpansController < Api::V1::ApiController
  before_action :authenticate_activated_user!

  def show
    @time_span = current_api_user.accessible_time_spans.find_by!(uuid: params[:id])
  end

  def index
    @time_spans = current_api_user.accessible_time_spans.includes(:contact, :collection)

    if params[:contact_url]
      @time_spans = @time_spans.joins(:contact).where(contacts: {url: params[:contact_url]})
    end

    if params[:status]
      @time_spans = @time_spans.status(params[:status])
    end

    if ["true", "1"].include?(params[:current].to_s)
      @time_spans = @time_spans.current
    end

    if params[:classification]
      @time_spans = @time_spans.classification(params[:classification])
    end

    if params[:subject_type]
      @time_spans = @time_spans.subject_type(params[:subject_type])
    end

    @time_spans = @time_spans.order(starts_at: :desc).limit(params[:limit] || 16).select { |a| a.subject }

    @time_spans
  end
end
