# frozen_string_literal: true

require_relative "feature_helper"

RSpec.feature "Navigate works", type: :feature do
  include FeatureHelper

  scenario "read only" do
    allow(RkdArtist).to receive(:search_rkd) { [rkd_artists(:rkd_artist2)] }

    login "qkunst-test-read_only@murb.nl"

    click_on "Collecties"
    expect(page).not_to have_content("Bewerk")
    within "#responsive-menu" do
      click_on "Werken"
    end
    click_on "Work1"
    expect(page).to have_content("artist_1, firstname (YAC, 1900 - 2000)")
    expect(page).not_to have_content("Bewerk")
    click_on "artist_1, firstname (YAC, 1900 - 2000)"
    expect(page).not_to have_content("Work6")
    expect(page).not_to have_content("Bewerk")
    expect(page).to have_content("Work1")
    expect(page).to have_content("Collection 1")
    expect(page).not_to have_content("RKD")
    within "#responsive-menu" do
      click_on "Vervaardigers"
    end
    expect(page).to have_content("artist_1")
    expect(page).to have_content("artist_2")
    expect(page).not_to have_content("artist_3")
  end
  scenario "registrator" do
    ra = rkd_artists(:rkd_artist2)
    ra.api_response = JSON.parse(File.read(File.join(Rails.root, "spec", "fixtures", "rkd_api_response1.json")))
    ra.save
    allow(RkdArtist).to receive(:search_rkd) { [ra] }

    login "qkunst-regular-user-with-collection@murb.nl"

    click_on "Collecties"
    within "#responsive-menu" do
      click_on "Vervaardigers"
    end
    expect(page).not_to have_content("artist_4 achternaam")
    expect(page).to have_content("artist_1 firstname")
    expect(page).to have_content("artist_2 achternaam")
    expect(page).not_to have_content("Bewerk")
    click_on "artist_2 achternaam"
    expect(page).not_to have_content("Work4")
    expect(page).to have_content("Bewerk")
    expect(page).to have_content("Work2")
    expect(page).to have_content("Work5")
    expect(page).to have_content("Collection 1")
    expect(page).to have_content("RKD")
    click_on "Bewerk"
    fill_in "Voornaam", with: "Nieuwe voornaam"
    click_on "Vervaardiger bewaren"
    expect(page).to have_content "Nieuwe voornaam"
    expect(page).to have_content("Collection 1")
    click_on "Maak RKD koppeling"
    click_on ": Artist 2"
    expect(page).to have_content("Haas, Konijn")
    expect(page).to have_content("Den Haag")
    click_on "Koppel met deze vervaardiger"
    expect(page).to have_content("De vervaardiger is gekoppeld met een RKD artist")
    click_on "Neem informatie over uit het RKD"
    expect(page).to have_content("De gegevens zijn bijgewerkt met de gegevens uit het RKD")
    expect(page).to have_content("Koninklijke Academie van Beeldende Kunsten (Den Haag)")
    expect(page).not_to have_content("Combineer")
  end
  scenario "appraiser" do
    ra = rkd_artists(:rkd_artist2)
    ra.api_response = JSON.parse(File.read(File.join(Rails.root, "spec", "fixtures", "rkd_api_response1.json")))
    ra.save
    allow(RkdArtist).to receive(:search_rkd) { [ra] }

    login "qkunst-test-appraiser@murb.nl"

    click_on "Collecties"
    click_on "Collection 1"
    within "#responsive-menu" do
      click_on "Vervaardigers"
    end
    expect(page).not_to have_content("artist_4 achternaam")
    expect(page).to have_content("artist_1 firstname")
    expect(page).to have_content("artist_2 achternaam")
    expect(page).not_to have_content("Bewerk")
    click_on "artist_2 achternaam"
    expect(page).not_to have_content("Work4")
    expect(page).to have_content("Bewerk")
    expect(page).to have_content("Work2")
    expect(page).to have_content("Work5")
    expect(page).to have_content("Collection 1")
    expect(page).to have_content("RKD")
    click_on "Bewerk"
    fill_in "Voornaam", with: "Nieuwe voornaam"
    click_on "Vervaardiger bewaren"
    expect(page).to have_content "Nieuwe voornaam"
    expect(page).to have_content("Collection 1")
    click_on "Maak RKD koppeling"
    click_on ": Artist 2"
    expect(page).to have_content("Haas, Konijn")
    expect(page).to have_content("Den Haag")
    click_on "Koppel met deze vervaardiger"
    expect(page).to have_content("De vervaardiger is gekoppeld met een RKD artist")
    click_on "Neem informatie over uit het RKD"
    expect(page).to have_content("De gegevens zijn bijgewerkt met de gegevens uit het RKD")
    expect(page).to have_content("Koninklijke Academie van Beeldende Kunsten (Den Haag)")
    expect(page).not_to have_content("Combineer")
    first("h3 small a").click
    fill_in "Vanaf (jaar)", with: 2000
    fill_in "Tot (jaar)", with: 2001
    select "Involvement 1"
    click_on "Vervaardigersbetrekking toevoegen"
    expect(page).to have_content("Betrekking toegevoegd")
  end
  scenario "advisor" do
    ra = rkd_artists(:rkd_artist2)
    ra.api_response = JSON.parse(File.read(File.join(Rails.root, "spec", "fixtures", "rkd_api_response1.json")))
    ra.save
    allow(RkdArtist).to receive(:search_rkd) { [ra] }

    login "qkunst-test-advisor@murb.nl"

    click_on "Collecties"
    within "#responsive-menu" do
      click_on "Vervaardigers"
    end
    expect(page).not_to have_content("artist_4 achternaam")
    expect(page).to have_content("artist_1 firstname")
    expect(page).to have_content("artist_2 achternaam")
    expect(page).not_to have_content("Bewerk")
    click_on "artist_2 achternaam"
    expect(page).not_to have_content("Work4")
    expect(page).to have_content("Bewerk")
    expect(page).to have_content("Work2")
    expect(page).to have_content("Work5")
    expect(page).to have_content("Collection 1")
    expect(page).to have_content("RKD")
    click_on "Bewerk"
    fill_in "Voornaam", with: "Nieuwe voornaam"
    click_on "Vervaardiger bewaren"
    expect(page).to have_content "Nieuwe voornaam"
    expect(page).to have_content("Collection 1")
    click_on "Maak RKD koppeling"
    click_on ": Artist 2"
    expect(page).to have_content("Haas, Konijn")
    expect(page).to have_content("Den Haag")
    click_on "Koppel met deze vervaardiger"
    expect(page).to have_content("De vervaardiger is gekoppeld met een RKD artist")
    click_on "Neem informatie over uit het RKD"
    expect(page).to have_content("De gegevens zijn bijgewerkt met de gegevens uit het RKD")
    expect(page).to have_content("Koninklijke Academie van Beeldende Kunsten (Den Haag)")
    expect(page).not_to have_content("Combineer")
    first("h3 small a").click
    fill_in "Vanaf (jaar)", with: 2000
    fill_in "Tot (jaar)", with: 2001
    select "Involvement 1"
    click_on "Vervaardigersbetrekking toevoegen"
    expect(page).to have_content("Betrekking toegevoegd")
    click_on "Beheer RKD koppeling"
  end
  scenario "compliance" do
    ra = rkd_artists(:rkd_artist2)
    ra.api_response = JSON.parse(File.read(File.join(Rails.root, "spec", "fixtures", "rkd_api_response1.json")))
    ra.save
    allow(RkdArtist).to receive(:search_rkd) { [ra] }

    login "qkunst-test-compliance@murb.nl"

    click_on "Collecties"
    within "#responsive-menu" do
      click_on "Vervaardigers"
    end
    expect(page).not_to have_content("artist_4 achternaam")
    expect(page).to have_content("artist_1 firstname")
    expect(page).to have_content("artist_2 achternaam")
    expect(page).not_to have_content("Bewerk")
    click_on "artist_2 achternaam"
    expect(page).not_to have_content("Work4")
    expect(page).not_to have_content("Bewerk")
    expect(page).to have_content("Work2")
    expect(page).to have_content("Work5")
    expect(page).to have_content("Collection 1")
    expect(page).to have_content("RKD")
    click_on ": Artist 2"
    expect(page).to have_content("Haas, Konijn")
    expect(page).to have_content("Den Haag")
  end
  scenario "facility" do
    allow(RkdArtist).to receive(:search_rkd) { rkd_artists(:rkd_artist2) }

    login "qkunst-test-facility_manager@murb.nl"

    click_on "Collecties"
    within "#responsive-menu" do
      click_on "Vervaardigers"
    end

    expect(page).not_to have_content("artist_4 achternaam")
    expect(page).to have_content("artist_1 firstname")
    expect(page).to have_content("artist_2 achternaam")
    expect(page).not_to have_content("Bewerk")
    click_on "artist_2 achternaam"
    expect(page).not_to have_content("Work4")
    expect(page).not_to have_content("Bewerk")
    expect(page).to have_content("Work2")
    expect(page).to have_content("Work5")
    expect(page).to have_content("Collection 1")
    expect(page).not_to have_content("RKD")
  end
end
