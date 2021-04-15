# frozen_string_literal: true

require_relative "feature_helper"

RSpec.feature "Signin in and out" do
  include FeatureHelper

  it "should sign in a regular user using password login" do
    password_login(users(:qkunst))
    expect(page.body).to match("Succesvol ingelogd")
  end

  it "should not allow password login as admin user" do
    password_login(users(:admin))
    expect(page.body).not_to match("Succesvol ingelogd")
    expect(page.body).to match("U dient in te loggen met de inlogmethode van uw organisatie")
  end

  it "should allow oauth login as admin user" do
    oauth_login(users(:admin))
    expect(page.body).to match("Succesvol geautoriseerd met een Google account")
    expect(page.body).not_to match("U dient in te loggen met de inlogmethode van uw organisatie")
  end

  it "should allow oauth login as never oauthed admin user" do
    user = users(:supposed_admin_without_oauth)
    expect(user.oauth_provider).to eq(nil)
    expect(user.oauth_subject).to eq(nil)

    oauth_login(user)
    expect(page.body).to match("Succesvol geautoriseerd met een Google account")
    expect(page.body).not_to match("U dient in te loggen met de inlogmethode van uw organisatie")
    user.reload
    expect(user.oauth_provider).to eq("google_oauth2")
    expect(user.domain).to eq("qkunst.nl")
    expect(user.oauth_subject).not_to eq(nil)
  end
end