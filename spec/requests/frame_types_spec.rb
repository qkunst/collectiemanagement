require 'rails_helper'

RSpec.describe "FrameTypes", type: :request do
  describe "GET /frame_types" do
    it "works! (now write some real specs)" do
      get frame_types_path
      expect(response).to have_http_status(200)
    end
  end
end
