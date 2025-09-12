# frozen_string_literal: true

require_relative "feature_helper"

RSpec.feature "", type: :feature do
  include FeatureHelper
  extend FeatureHelper

  describe "Secure communication" do
    describe "configuration" do
      let(:production_config) { File.read(Rails.root.join("config/environments/production.rb")) }
      it "has ssl config [QSECIMP0023]" do
        expect(production_config.match(/(config.force_ssl\s*=\s*([a-z]*))/)).to be_present
      end

      it "production config enforces SSL [QSECIMP0023]" do
        expect(production_config.scan(/(config.force_ssl\s*=\s*([a-z]*))/).map { |a| a.last }).not_to include "false"
      end

      it "https config for collectionmanagement.qkunst.nl [QSECIMP0023]" do
        headers = Open3.popen3("curl -v http://collectiemanagement.qkunst.nl") do |stdin, stdout, stderr, thread|
          stderr.read.chomp
        end

        expect(headers).to match "\n< Location: https://collectiemanagement.qkunst.nl/\r\n"

        headers = Open3.popen3("curl -v https://collectiemanagement.qkunst.nl") do |stdin, stdout, stderr, thread|
          stderr.read.chomp
        end

        expect(headers).to match "\n< strict-transport-security: max-age=63072000"
        expect(headers).to match "TLS handshake"
        expect(headers).to match "Let's Encrypt"
      end
    end
  end
  describe "Mutation Log [QSECIMP0024]" do
    describe "User" do
      it "creates a version after sign in" do
        u = users(:user1)
        expect(u.versions.count).to eq(0)
        login(u.email)
        u.reload
        expect(u.versions.count).to eq(1)
      end
    end

    describe "Work" do
      it "creates a version after update" do
        w = works(:work1)
        expect(w.versions.count).to eq(0)
        w.update(title: "some other title")
        w.reload
        expect(w.versions.count).to eq(1)
      end
    end
  end
end
