require 'rails_helper'

RSpec.describe WorksController, type: :controller do
  include Devise::Test::ControllerHelpers


  describe "#aggregations" do
    it "should allow to be initialized" do
      works = [works(:work1),works(:work2)]
      controller = WorksController.new
      # expect()
      aggregations = controller.aggregations works, [:title, :themes, :subset, :grade_within_collection]
      expect(aggregations.count).to eq 4
      expect(aggregations[:title][:work1]).to eq 1
      expect(aggregations[:themes][themes(:wind)]).to eq 2
      expect(aggregations[:grade_within_collection][:a]).to eq 2

    end
  end

end
