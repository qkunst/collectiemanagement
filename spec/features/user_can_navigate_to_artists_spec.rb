# frozen_string_literal: true

require_relative "feature_helper"

RSpec.feature "Navigate works", type: :feature do
  include FeatureHelper

  let(:fake_rkd_artist) { RKD::Artist.new(identifier: 123, name: "Artist 2") }

  before do
    allow(RKD::Artist).to receive(:search).and_return([fake_rkd_artist])
    allow(RKD::Artist).to receive(:find).and_return(fake_rkd_artist)
  end

  scenario "read only" do
    login "qkunst-test-read_only@murb.nl"

    User.find_by_email("qkunst-test-read_only@murb.nl")

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
    click_on "123: Artist 2"
    expect(page).to have_content("123: Artist 2")

    click_on "Koppel met deze vervaardiger"
    expect(page).to have_content("De vervaardiger is gekoppeld")
    # click_on "Neem informatie over uit het RKD"
    # expect(page).to have_content("De gegevens zijn bijgewerkt met de gegevens uit het RKD")
    # expect(page).to have_content("Koninklijke Academie van Beeldende Kunsten (Den Haag)")
    expect(page).not_to have_content("Combineer")
  end
  scenario "appraiser" do
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
    click_on "123: Artist 2"
    expect(page).to have_content("123: Artist 2")

    click_on "Koppel met deze vervaardiger"
    expect(page).to have_content("De vervaardiger is gekoppeld")

    # click_on "Neem informatie over uit het RKD"
    # expect(page).to have_content("De gegevens zijn bijgewerkt met de gegevens uit het RKD")
    # expect(page).to have_content("Koninklijke Academie van Beeldende Kunsten (Den Haag)")
    expect(page).not_to have_content("Combineer")
    first("h3 small a").click
    fill_in "Vanaf (jaar)", with: 2000
    fill_in "Tot (jaar)", with: 2001
    select "Involvement 1"
    click_on "Vervaardigersbetrekking toevoegen"
    expect(page).to have_content("Betrekking toegevoegd")
  end
  scenario "advisor" do
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
    click_on "123: Artist 2"
    expect(page).to have_content("123: Artist 2")
    click_on "Koppel met deze vervaardiger"
    expect(page).to have_content("De vervaardiger is gekoppeld")
    # click_on "Neem informatie over uit het RKD"
    # expect(page).to have_content("De gegevens zijn bijgewerkt met de gegevens uit het RKD")
    # expect(page).to have_content("Koninklijke Academie van Beeldende Kunsten (Den Haag)")

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
    click_on "123: Artist 2"
    expect(page).to have_content("123: Artist 2")

    expect(page).not_to have_content "Koppel met deze vervaardiger"
  end
  scenario "facility" do
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
