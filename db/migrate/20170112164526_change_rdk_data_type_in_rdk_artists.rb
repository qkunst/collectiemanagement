# frozen_string_literal: true

class ChangeRdkDataTypeInRdkArtists < ActiveRecord::Migration[5.0]
  def change
    remove_column :rdk_artists, :api_response
    add_column :rdk_artists, :api_response, :json
  end
end
