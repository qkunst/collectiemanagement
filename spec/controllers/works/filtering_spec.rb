# frozen_string_literal: true

require "rails_helper"

class WorksFilteringTestClass
  include Works::Filtering

  def current_user
    User.first
  end

  attr_writer :params

  def params
    @params || {}
  end
end

RSpec.describe Works::Filtering, type: :model do
  subject { WorksFilteringTestClass.new }
  describe "#set_selection_filter" do
    it "returns empty hash when none" do
      expect(subject.send(:set_selection_filter)).to eq({})
    end

    it "returns empty hash when none" do
      subject.params = {filter: {"cluster" => ["not_set"], "cluster_id" => [1, 2]}} # filter[cluster][]=not_set&filter[cluster_id][]=1&filter[cluster_id][]=2
      expect(subject.send(:set_selection_filter)).to eq({"cluster" => [nil], "cluster_id" => [1, 2]})
    end
  end
end
