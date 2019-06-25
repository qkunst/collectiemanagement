# frozen_string_literal: true

require 'rails_helper'

RSpec.feature "UserCanNavigateToWorks", type: :feature do
  scenario "read_only" do
    visit root_path
    expect(page).to have_content('QKunst Collectiebeheer')
    expect(page).to have_content('Welkom')
    first(".large-12.columns .button").click
    fill_in("E-mailadres", with: "qkunst-test-read_only_user@murb.nl")
    fill_in("Wachtwoord", with: "password")
    first("#new_user input[type=submit]").click
    expect(page).to have_content('Succesvol ingelogd')
    expect(page).to have_content('Ingelogd als qkunst-test-read_only_user@murb.nl')
    click_on "Collecties"
    expect(page).to have_content('Ingelogd als qkunst-test-read_only_user@murb.nl')
    expect(page).to have_content('Collection 1')
    expect(page).not_to have_content("+ Voeg werk toe")
    expect(page).not_to have_content('Bewerk')
    expect(page).to have_content('Doorzoek de werken')
    click_on "Werken"
    expect(page).to have_content('Deze collectie bevat 3 werken')
    expect(page).not_to have_content('Bewerk')
    click_on "Work1"
    expect(page).to have_content('Details')
    expect(page).not_to have_content('Bewerk')

  end
  scenario "advisor" do
    visit root_path
    expect(page).to have_content('QKunst Collectiebeheer')
    expect(page).to have_content('Welkom')
    first(".large-12.columns .button").click
    fill_in("E-mailadres", with: "qkunst-test-advisor@murb.nl")
    fill_in("Wachtwoord", with: "password")
    first("#new_user input[type=submit]").click
    expect(page).to have_content('Succesvol ingelogd')
    expect(page).to have_content('Ingelogd als qkunst-test-advisor@murb.nl')
    click_on "Collecties"
    expect(page).to have_content('Collection 1')
    expect(page).to have_content('Doorzoek de werken')
    click_on "Werken"
    expect(page).to have_content('Deze collectie bevat 3 werken')
    expect(page).to have_content('Deelcollectie')
    expect(page).to have_content('Herkomst')
    click_on "Work1"
    expect(page).to have_content('Details')
    expect(page).to have_content('Q001')
    first("h1 small a").click
    fill_in("Adres en/of gebouw(deel)", with: "Grotestraat 1")
    check("Na bewaren direct de volgende bewerken")
    click_on "Kunstwerk bewaren"
    fill_in("Adres en/of gebouw(deel)", with: "Grotestraat 2")
    click_on "Kunstwerk bewaren"
    expect(page).to have_content('Q002')
    expect(page).to have_content('Het werk is bijgewerkt')
    expect(page).to have_content('Grotestraat 2')
    click_on "◀"
    expect(page).to have_content('Q001')
    expect(page).to have_content('Grotestraat 1')
    first(".detailed_data table tr a").click
    fill_in("Verdieping", with: "vurdiepB")
    click_on "Kunstwerk bewaren"
    expect(page).to have_content('Het werk is bijgewerkt')
    expect(page).to have_content("VerdiepingvurdiepB (bewerk)")
  end
  scenario "registrator" do
    visit root_path
    expect(page).to have_content('QKunst Collectiebeheer')
    expect(page).to have_content('Welkom')
    first(".large-12.columns .button").click
    fill_in("E-mailadres", with: "qkunst-regular-withcollection-user@murb.nl")
    fill_in("Wachtwoord", with: "password")
    first("#new_user input[type=submit]").click
    expect(page).to have_content('Succesvol ingelogd')
    expect(page).to have_content('Ingelogd als qkunst-regular-withcollection-user@murb.nl')
    click_on "Collecties"
    expect(page).to have_content('Ingelogd als qkunst-regular-withcollection-user@murb.nl')
    expect(page).to have_content('Collection 1')
    expect(page).to have_content('Doorzoek de werken')
    click_on "Werken"
    expect(page).to have_content('Deze collectie bevat 3 werken')
    expect(page).to have_content('Deelcollectie')
    expect(page).to have_content('Herkomst')
    click_on "Work1"
    expect(page).to have_content('Details')
    expect(page).to have_content('Q001')
    first("h1 small a").click
    fill_in("Adres en/of gebouw(deel)", with: "Grotestraat 1")
    check("Na bewaren direct de volgende bewerken")
    click_on "Kunstwerk bewaren"
    fill_in("Adres en/of gebouw(deel)", with: "Grotestraat 2")
    click_on "Kunstwerk bewaren"
    expect(page).to have_content('Q002')
    expect(page).to have_content('Het werk is bijgewerkt')
    expect(page).to have_content('Grotestraat 2')
    click_on "◀"
    expect(page).to have_content('Q001')
    expect(page).to have_content('Grotestraat 1')
    first(".detailed_data table tr a").click
    fill_in("Verdieping", with: "vurdiepB")
    click_on "Kunstwerk bewaren"
    expect(page).to have_content('Het werk is bijgewerkt')
    expect(page).to have_content("VerdiepingvurdiepB (bewerk)")
  end
  scenario "facility" do
    visit root_path
    first(".large-12.columns .button").click
    fill_in("E-mailadres", with: "qkunst-test-facility_manager@murb.nl")
    fill_in("Wachtwoord", with: "password")
    first("#new_user input[type=submit]").click
    click_on "Collecties"
    expect(page).to have_content('Ingelogd als qkunst-test-facility_manager@murb.nl')
    click_on "Work1"
    expect(page).not_to have_content('Bewerk gegevens')
    expect(page).to have_content('bewerk')
    first(".detailed_data table tr a").click
    expect(page).to have_content('Bewerk locatie')
    fill_in('Verdieping', with: 'Nieuwe verdieping')
    click_on "Kunstwerk bewaren"
    expect(page).to have_content('Nieuwe verdieping')
  end
end
