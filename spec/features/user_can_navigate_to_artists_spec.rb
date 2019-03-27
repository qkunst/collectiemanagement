# frozen_string_literal: true

require 'rails_helper'

RSpec.feature "UserCanNavigateToWorks", type: :feature do
  scenario "read_only" do
    allow(RkdArtist).to receive(:search_rkd) { [rkd_artists(:rkd_artist2)] }

    visit root_path
    # user can navigate to works tests basic assumptions more extensively
    first(".large-12.columns .button").click
    fill_in("E-mailadres", with: "qkunst-test-read_only_user@murb.nl")
    fill_in("Wachtwoord", with: "password")
    first("#new_user input[type=submit]").click
    click_on "Collecties"
    expect(page).not_to have_content('Bewerk')
    expect(page).not_to have_content('Vervaardigers')
    click_on "Werken"
    click_on "Work6"
    expect(page).to have_content('artist_4 achternaam')
    expect(page).not_to have_content('Bewerk')
    click_on "artist_4 achternaam"
    expect(page).not_to have_content('Work4')
    expect(page).not_to have_content('Bewerk')
    expect(page).to have_content('Work6')
    expect(page).to have_content('Collection 3')
    expect(page).not_to have_content('RKD')

  end
  scenario "registrator" do
    ra = rkd_artists(:rkd_artist2)
    ra.api_response = JSON.parse(File.open(File.join(Rails.root,"spec","fixtures","rkd_api_response1.json")).read)
    ra.save
    allow(RkdArtist).to receive(:search_rkd) { [ra] }

    visit root_path
    # user can navigate to works tests basic assumptions more extensively
    first(".large-12.columns .button").click
    fill_in("E-mailadres", with: "qkunst-regular-withcollection-user@murb.nl")
    fill_in("Wachtwoord", with: "password")
    first("#new_user input[type=submit]").click
    click_on "Collecties"
    click_on "Vervaardigers"
    expect(page).not_to have_content('artist_4 achternaam')
    expect(page).to have_content('artist_1 firstname')
    expect(page).to have_content('artist_2 achternaam')
    expect(page).not_to have_content('Bewerk')
    click_on "artist_2 achternaam"
    expect(page).not_to have_content('Work4')
    expect(page).to have_content('Bewerk')
    expect(page).to have_content('Work2')
    expect(page).to have_content('Work5')
    expect(page).to have_content('Collection 1')
    expect(page).to have_content('RKD')
    click_on "Bewerk"
    fill_in "Voornaam", with: "Nieuwe voornaam"
    click_on "Vervaardiger bewaren"
    expect(page).to have_content "Nieuwe voornaam"
    expect(page).to have_content('Collection 1')
    click_on "Beheer RKD koppeling voor deze vervaardiger"
    click_on ": Artist 2"
    expect(page).to have_content('Haas, Konijn')
    expect(page).to have_content('Den Haag')
    click_on "Koppel met deze vervaardiger"
    expect(page).to have_content('De vervaardiger is gekoppeld met een RKD artist')
    click_on "Neem informatie over uit het RKD"
    expect(page).to have_content('De gegevens zijn bijgewerkt met de gegevens uit het RKD')
    expect(page).to have_content('Koninklijke Academie van Beeldende Kunsten (Den Haag)')
    expect(page).not_to have_content('Combineer')
  end
  scenario "appraiser" do
    ra = rkd_artists(:rkd_artist2)
    ra.api_response = JSON.parse(File.open(File.join(Rails.root,"spec","fixtures","rkd_api_response1.json")).read)
    ra.save
    allow(RkdArtist).to receive(:search_rkd) { [ra] }
    visit root_path
    # user can navigate to works tests basic assumptions more extensively
    first(".large-12.columns .button").click
    fill_in("E-mailadres", with: "qkunst-test-appraiser@murb.nl")
    fill_in("Wachtwoord", with: "password")
    first("#new_user input[type=submit]").click
    click_on "Collecties"
    click_on "Vervaardigers"
    expect(page).not_to have_content('artist_4 achternaam')
    expect(page).to have_content('artist_1 firstname')
    expect(page).to have_content('artist_2 achternaam')
    expect(page).not_to have_content('Bewerk')
    click_on "artist_2 achternaam"
    expect(page).not_to have_content('Work4')
    expect(page).to have_content('Bewerk')
    expect(page).to have_content('Work2')
    expect(page).to have_content('Work5')
    expect(page).to have_content('Collection 1')
    expect(page).to have_content('RKD')
    click_on "Bewerk"
    fill_in "Voornaam", with: "Nieuwe voornaam"
    click_on "Vervaardiger bewaren"
    expect(page).to have_content "Nieuwe voornaam"
    expect(page).to have_content('Collection 1')
    click_on "Beheer RKD koppeling voor deze vervaardiger"
    click_on ": Artist 2"
    expect(page).to have_content('Haas, Konijn')
    expect(page).to have_content('Den Haag')
    click_on "Koppel met deze vervaardiger"
    expect(page).to have_content('De vervaardiger is gekoppeld met een RKD artist')
    click_on "Neem informatie over uit het RKD"
    expect(page).to have_content('De gegevens zijn bijgewerkt met de gegevens uit het RKD')
    expect(page).to have_content('Koninklijke Academie van Beeldende Kunsten (Den Haag)')
    expect(page).not_to have_content('Combineer')
    first("h3 small a").click
    fill_in "Vanaf (jaar)", with: 2000
    fill_in "Tot (jaar)", with: 2001
    select "Involvement 1"
    click_on "Vervaardigersbetrekking toevoegen"
    expect(page).to have_content('Betrekking toegevoegd')
  end
  scenario "advisor" do
    ra = rkd_artists(:rkd_artist2)
    ra.api_response = JSON.parse(File.open(File.join(Rails.root,"spec","fixtures","rkd_api_response1.json")).read)
    ra.save
    allow(RkdArtist).to receive(:search_rkd) { [ra] }

    visit root_path
    # user can navigate to works tests basic assumptions more extensively
    first(".large-12.columns .button").click
    fill_in("E-mailadres", with: "qkunst-test-advisor@murb.nl")
    fill_in("Wachtwoord", with: "password")
    first("#new_user input[type=submit]").click
    click_on "Collecties"
    click_on "Vervaardigers"
    expect(page).not_to have_content('artist_4 achternaam')
    expect(page).to have_content('artist_1 firstname')
    expect(page).to have_content('artist_2 achternaam')
    expect(page).not_to have_content('Bewerk')
    click_on "artist_2 achternaam"
    expect(page).not_to have_content('Work4')
    expect(page).to have_content('Bewerk')
    expect(page).to have_content('Work2')
    expect(page).to have_content('Work5')
    expect(page).to have_content('Collection 1')
    expect(page).to have_content('RKD')
    click_on "Bewerk"
    fill_in "Voornaam", with: "Nieuwe voornaam"
    click_on "Vervaardiger bewaren"
    expect(page).to have_content "Nieuwe voornaam"
    expect(page).to have_content('Collection 1')
    click_on "Beheer RKD koppeling voor deze vervaardiger"
    click_on ": Artist 2"
    expect(page).to have_content('Haas, Konijn')
    expect(page).to have_content('Den Haag')
    click_on "Koppel met deze vervaardiger"
    expect(page).to have_content('De vervaardiger is gekoppeld met een RKD artist')
    click_on "Neem informatie over uit het RKD"
    expect(page).to have_content('De gegevens zijn bijgewerkt met de gegevens uit het RKD')
    expect(page).to have_content('Koninklijke Academie van Beeldende Kunsten (Den Haag)')
    expect(page).not_to have_content('Combineer')
    first("h3 small a").click
    fill_in "Vanaf (jaar)", with: 2000
    fill_in "Tot (jaar)", with: 2001
    select "Involvement 1"
    click_on "Vervaardigersbetrekking toevoegen"
    expect(page).to have_content('Betrekking toegevoegd')
  end
  scenario "facility" do
    allow(RkdArtist).to receive(:search_rkd) { rkd_artists(:rkd_artist2) }
    visit root_path
    # user can navigate to works tests basic assumptions more extensively
    first(".large-12.columns .button").click
    fill_in("E-mailadres", with: "qkunst-test-facility_manager@murb.nl")
    fill_in("Wachtwoord", with: "password")
    first("#new_user input[type=submit]").click
    click_on "Collecties"
    click_on "Vervaardigers"
    expect(page).not_to have_content('artist_4 achternaam')
    expect(page).to have_content('artist_1 firstname')
    expect(page).to have_content('artist_2 achternaam')
    expect(page).not_to have_content('Bewerk')
    click_on "artist_2 achternaam"
    expect(page).not_to have_content('Work4')
    expect(page).not_to have_content('Bewerk')
    expect(page).to have_content('Work2')
    expect(page).to have_content('Work5')
    expect(page).to have_content('Collection 1')
    expect(page).not_to have_content('RKD')
  end
end
