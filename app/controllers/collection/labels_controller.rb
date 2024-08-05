# frozen_string_literal: true

class Collection::LabelsController < ApplicationController
  before_action :set_collection, only: [:index] # includes authentication

  def index
    respond_to do |format|
      format.pdf {
        labels = Collections::NumberLabels.new(
          offset: params[:offset] || 1,
          amount: params[:amount] || 16,
          collection: @collection,
          subtext: "Bij schade, verplaatsing of vragen contact opnemen met kunstzaken"
        )

        send_data labels.render
      }
    end
  end
end
