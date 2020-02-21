# frozen_string_literal: true

require 'rails_helper'


RSpec.describe MethodCache, type: :model do
  describe "Artist implementation geoname_ids" do
    it "should return nil if unset" do
      expect(Artist.new.cached_geoname_ids).to eq(nil)
    end
    it "should return an empty array after save" do
      expect(Artist.create(first_name: "test").cached_geoname_ids).to eq([])
    end
    it "should return array of ids when involvements exist" do
      a = Artist.new
      allow(a).to receive(:geoname_ids).and_return([20,12,2])
      a.save
      expect(a.cached_geoname_ids).to eq([20,12,2])
    end
  end

end
