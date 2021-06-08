# frozen_string_literal: true

require_relative "feature_helper"

RSpec.feature "Admin can review", type: :feature do
  include FeatureHelper

  scenario "modified works on collection level and work level" do
    login "qkunst-admin-user@murb.nl"

    click_on "Collecties"
    if page.body.match?("id=\"collections-list\"")
      within "#collections-list" do
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
