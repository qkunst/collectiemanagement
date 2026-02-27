# frozen_string_literal: true

class Api::V1::WorkEventsController < Api::V1::ApiController
  protect_from_forgery with: :null_session

  before_action :authenticate_activated_user!
  before_action :set_collection
  before_action :set_work

  def create
    work_event_params = params.require("work_event").permit(:contact_uri, :event_type, :status, :time_span_uuid, :comments, contact: [:name, :address, :external, :url, :remote_data])

    if work_event_params[:contact_uri]
      contact = Contact.find_or_initialize_by(
        collection: @work.collection,
        external: true,
        url: work_event_params[:contact_uri]
      )
    else
      contact = Contact.new(work_event_params[:contact])
      contact.collection = @work.collection
      contact.external = true
    end

    contact.save

    @time_span = if work_event_params[:time_span_uuid]
      time_span = @work.time_spans.find_by!(uuid: work_event_params[:time_span_uuid])
      raise "Non matching customer_uri for time span #{time_span.contact_url} != #{work_event_params[:contact_uri]}" if time_span.contact_url && (time_span.contact_url != work_event_params[:contact_uri])

      if work_event_params[:status] == "finished"
        time_span.finish
      else
        time_span.status = work_event_params[:status]
      end
      time_span
    else
      TimeSpan.new(
        subject: @work,
        collection: @work.collection,
        contact: contact,
        status: work_event_params[:status],
        classification: work_event_params[:event_type],
        starts_at: Time.current,
        comments: work_event_params[:comments]
      )
    end

    save_result = @time_span.save

    if save_result
      render @time_span
    else
      unprocessable_entity
    end
  end

  private

  def set_collection
    @collection ||= @user.accessible_collections.find(params[:collection_id]) if params[:collection_id]
  end

  def set_work
    @collection ||= Work.find(params[:id])&.collection
    api_authorize! :create_work_events_api, @collection
    @work = @collection.works_including_child_works.find(params[:work_id])
  end
end
