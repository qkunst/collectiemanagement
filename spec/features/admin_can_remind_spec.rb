# frozen_string_literal: true

require_relative 'feature_helper'

RSpec.feature "Admin can set reminders", type: :feature do
  include FeatureHelper

  scenario "on a global level" do
    login "qkunst-admin-user@murb.nl"

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

  scenario "on collection-level" do
    login "qkunst-admin-user@murb.nl"

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

