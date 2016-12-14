require 'rails_helper'

RSpec.describe WorksController, type: :controller do
  include Devise::Test::ControllerHelpers


  describe "#aggregations" do
    it "should allow to be initialized" do
      works = [works(:work1),works(:work2)]
      controller = WorksController.new
      p controller.aggregations works, [:title]

    end
  end

end
