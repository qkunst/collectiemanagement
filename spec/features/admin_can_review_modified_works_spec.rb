# frozen_string_literal: true

require_relative 'feature_helper'

RSpec.feature "Admin can review", type: :feature do
  include FeatureHelper

  scenario "modified works on collection level and work level" do
    visit root_path
    first(".large-12.columns .button").click
    fill_in("E-mailadres", with: "qkunst-admin-user@murb.nl")
    fill_in("Wachtwoord", with: "password")
    first("#new_user input[type=submit]").click
    click_on "Collecties"
    if page.body.match("id=\"list-to-filter\"")
      within "#list-to-filter" do
        click_on "Collection 1"
      end
    end
    within "#responsive-menu" do
      click_on "Beheer"
    end
    click_on "Recent gewijzigd"
    expect(page.body).not_to match("Q001")

    w1 = works(:work1)
    w1.location = "Nieuwe locatie"
    w1.save

    visit page.current_url
    click_on("Q001")
    click_on("Historie")
    expect(page.body).to match("Nieuwe locatie")
  end

end

