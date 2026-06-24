# frozen_string_literal: true

require_relative "feature_helper"

RSpec.feature "Signin in and out (QSECIMP0011)" do
  let(:user) { users(:qkunst) }
  include FeatureHelper

  it "should sign in a regular user using password login" do
    password_login(user)
    expect(page.body).to match("Succesvol ingelogd")
  end

  it "shouldn't reveal existence of an account [QSECIMP0074]" do
    password_login(user, "WrongPassword")
    expect(page.body).not_to match("Succesvol ingelogd")
    existing_user_response = page.find(".callout.alert").text
    expect(existing_user_response).to match("Ongeldig e-mailadres of wachtwoord.")

    password_login("nonexisting@example.com", "WrongPassword")
    expect(page.find(".callout.alert").text).to eq(existing_user_response)
  end

  it "tracks last sign in in user object [QSECIMP0016]" do
    original_current_sign_in_at = user.current_sign_in_at
    password_login(user)
    new_current_sign_in_at = User.find(user.id).current_sign_in_at
    expect(new_current_sign_in_at.to_i).to be > original_current_sign_in_at.to_i
  end

  it "tracks last sign in in user object [QSECIMP0016]" do
    expect {
      password_login(user)
    }.to change(user.versions, :count).from(0).to(1)
  end

  it "should not expose the user's existence [QSECIMP0074]" do
    password_login(user, "WrongPassword")
    expect(page.body).not_to match("Succesvol ingelogd")
    existing_user_response = page.find(".callout.alert").text
    expect(existing_user_response).to match("Ongeldig e-mailadres of wachtwoord.")

    password_login(users(:admin))
    expect(page.find(".callout.alert").text).to eq(existing_user_response)
  end

  context "admin" do
    let(:user) { users(:admin) }
    it "should allow oauth login as admin user" do
      oauth_login(user)
      expect(page.body).to match("Succesvol geautoriseerd met een Google account")
      expect(page.body).not_to match("Ongeldig e-mailadres of wachtwoord")
    end

    it "should not allow password login as admin user" do
      password_login(user)
      expect(page.body).not_to match("Succesvol ingelogd")
      expect(page.body).to match("Ongeldig e-mailadres of wachtwoord, of u mag niet op deze wijze inloggen.")
    end
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
