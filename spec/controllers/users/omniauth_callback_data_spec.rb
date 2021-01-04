# frozen_string_literal: true

require "rails_helper"

RSpec.describe Users::OmniauthCallbackData, type: :model do
  describe "Validations" do
    it "returns invalid when no params given" do
      a = Users::OmniauthCallbackData.new
      expect(a.valid?).to eq(false)
    end
    it "returns true when minimum params are given" do
      a = Users::OmniauthCallbackData.new(email: "a@a.a", oauth_provider: "google_oauth2", oauth_subject: "123")
      expect(a.valid?).to eq(true)
    end
    it "doesn't allow qkunst registrations for non qkunst" do
      a = Users::OmniauthCallbackData.new(email: "a@a.a", oauth_provider: "google_oauth2", oauth_subject: "123", qkunst: true)
      expect(a.valid?).to eq(false)
    end
    it "does allow qkunst registrations for qkunst domain" do
      a = Users::OmniauthCallbackData.new(email: "a@a.a", oauth_provider: "google_oauth2", oauth_subject: "123", qkunst: true, domain: "qkunst.nl")
      expect(a.valid?).to eq(true)
    end
  end
end