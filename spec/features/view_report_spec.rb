# frozen_string_literal: true

require_relative "feature_helper"

RSpec.feature "View report", type: :feature do
  include FeatureHelper

  scenario "as an admin" do
    login "qkunst-admin-user@murb.nl"

    visit collections_path

    click_on("Collection 1")

    within "#responsive-menu" do
      click_on("Rapportage")
    end

    click_on("Ververs rapportage")

    expect(page).to have_content("Room 1")
    expect(page).to have_content("Floor 1")
    expect(page).to have_content("Adres")
    expect(page).to have_content("Formaatcode onbekend3 l1")

    click_on("cluster1")

    expect(page).to have_content("Deze (gefilterde) collectie bevat 1 werk (van de 4 werken)")
    expect(page).to have_content("Q001")

    within "#responsive-menu" do
      click_on("Rapportage")
    end

    click_on "Overige"
    click_on "Onlangs geïnventariseerd"

    expect(page).to have_content("Deze (gefilterde) collectie bevat 2 werken (van de 4 werken)")
    expect(page).to have_content("Q001")
  end

  scenario "as a facility manager (limited)" do
    # required for TravisCI
    collections(:collection1).works_including_child_works.all.reindex!

    login users(:facility_manager)

    visit collections_path

    within "#responsive-menu" do
      click_on("Rapportage")
    end

    expect(page).not_to have_content("cluster1")
    expect(page).not_to have_content("Marktwaarde")

    expect(page).to have_content("Room 1")
    expect(page).to have_content("Floor 1")
    expect(page).to have_content("Adres")
  end
end
