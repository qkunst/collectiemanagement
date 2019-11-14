# frozen_string_literal: true

require 'rails_helper'

RSpec.feature "Admin can remind", type: :feature do
  scenario "on a global level" do
    visit root_path
    first(".large-12.columns .button").click
    fill_in("E-mailadres", with: "qkunst-admin-user@murb.nl")
    fill_in("Wachtwoord", with: "password")
    first("#new_user input[type=submit]").click

    visit reminders_path
    expect(page).to have_content('Herinneringen')

    visit new_reminder_path
    fill_in("Naam", with: "Mijn test herinnering")
    fill_in("Aantal dagen/weken/maanden...", with: 2)
    select("Dagen")

    click_on("Herinnering toevoegen")
    expect(page).to have_content('2 dagen na')

    click_on("Mijn test herinnering")
    click_on("Bewerk")
    fill_in("Begeleidende tekst", with: "begeleidende tekst voor deze herinnering")
    click_on("Herinnering bewaren")
    expect(page).to have_content("begeleidende tekst voor deze herinnering")

  end

  scenario "on a collection" do
    visit root_path
    first(".large-12.columns .button").click
    fill_in("E-mailadres", with: "qkunst-admin-user@murb.nl")
    fill_in("Wachtwoord", with: "password")
    first("#new_user input[type=submit]").click

    visit collection_reminders_path(Collection.first)
    expect(page).to have_content('Herinneringen')

    visit new_collection_reminder_path(Collection.first)
    fill_in("Naam", with: "Mijn test herinnering")
    fill_in("Aantal dagen/weken/maanden...", with: 2)
    select("Dagen")

    click_on("Herinnering toevoegen")
    expect(page).to have_content('2 dagen na')

    click_on("Mijn test herinnering")
    click_on("Bewerk")

    fill_in("Begeleidende tekst", with: "begeleidende tekst voor deze herinnering")
    click_on("Herinnering bewaren")
    expect(page).to have_content("begeleidende tekst voor deze herinnering")
    click_on("Mijn test herinnering")
    click_on("Bewerk")
    click_on("Verwijder")
    expect(page).not_to have_content("Mijn test herinnering")

  end

end

