# frozen_string_literal: true

class Api::V1::TimeSpansController < Api::V1::ApiController
  before_action :authenticate_activated_user!

  def show
    @time_span = current_api_user.accessible_time_spans.find_by!(uuid: params[:id])
  end

  def index
    @time_spans = current_api_user.accessible_time_spans.includes(:subject)

    if params[:contact_url]
      contact = current_api_user.accessible_contacts.find_by(url: params[:contact_url])
      @time_spans = @time_spans.where(contact: contact)
    end

    if params[:status]
      @time_spans = @time_spans.where(status: params[:status])
    end

    if [true, "true", 1].include?(params[:current])
      @time_spans = @time_spans.current
    end

    if params[:classification]
      @time_spans = @time_spans.where(classification: params[:classification])
    end

    @time_spans = @time_spans.order(starts_at: :desc).limit(params[:limit] || 16).select{|a| a.subject}

    @time_spans
  end
end