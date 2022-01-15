# frozen_string_literal: true

class Api::V1::TimeSpansController < Api::V1::ApiController
  before_action :authenticate_activated_user!

  def index
    @time_spans = @user.accessible_time_spans.current

    if params[:contact_url]
      contact = @user.accessible_contacts.find_by(url: params[:contact_url])
      @time_spans = @time_spans.where(contact: contact)
    end

    if params[:status]
      @time_spans = @time_spans.where(status: params[:status])
    end

    @time_spans
  end
end