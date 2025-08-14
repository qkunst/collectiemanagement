# frozen_string_literal: true

require_relative "feature_helper"

RSpec.feature "", type: :feature do
  include FeatureHelper
  extend FeatureHelper

  describe "Secure communication" do
    describe "configuration" do
      let(:production_config) { File.read(Rails.root.join("config/environments/production.rb")) }
      it "has ssl config" do
        expect(production_config.match(/(config.force_ssl\s*=\s*([a-z]*))/)).to be_present
      end

      it "production config enforces SSL" do
        expect(production_config.scan(/(config.force_ssl\s*=\s*([a-z]*))/).map { it.last }).not_to include "false"
      end

      it "https config for collectionmanagement.qkunst.nl" do
      end
    end
  end
  describe "Mutation Log" do
  end
end
