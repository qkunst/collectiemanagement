# frozen_string_literal: true

require_relative "feature_helper"

RSpec.feature "Filter from report", type: :feature do
  include FeatureHelper

  scenario "as an admin", requires_elasticsearch: true do
    inital_works_count = 2

    login "qkunst-admin-user@murb.nl"

    # required for TravisCI
    collections(:collection1).works_including_child_works.all.reindex!

    visit collections_path

    click_on("Collection 1")

    within "#responsive-menu" do
      click_on("Rapportage")
    end

    click_on("Geïnventariseerd")

    expect(page).to have_content("Er worden vanwege een filter #{I18n.translate "count.works", count: inital_works_count} getoond.")

    select "Compleet", from: "Weergave:"

    click_on("Filter")

    expect(page).to have_content("Interne opmerking bij werk 1")

    select "Compact", from: "Weergave:"

    click_on("Filter")

    expect(page).not_to have_content("Interne opmerking bij werk 1")
    expect(page).to have_content("Er worden vanwege een filter #{I18n.translate "count.works", count: inital_works_count} getoond.")

    check "Fotografie"

    click_on("Filter")

    expect(page).to have_content("vanwege een filter #{I18n.translate "count.works", count: inital_works_count - 1} getoond.")

    within "aside" do
      fill_in "q", with: "Bijzondere"
    end
    click_on("Filter")

    expect(page).to have_content("vanwege een filter #{I18n.translate "count.works", count: inital_works_count - 1} getoond.")

    url = page.current_url
    expect(url).to match "display=compact"
    expect(url).to match "q=Bijzondere"
    expect(url).to match(/filter\[inventoried\]\[\]=true/)
  end
end
