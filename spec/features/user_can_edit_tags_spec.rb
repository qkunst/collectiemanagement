require 'rails_helper'

RSpec.feature "UserCanEditTags", type: :feature do
  scenario "facility" do
    visit root_path
    first(".large-12.columns .button").click
    fill_in("E-mailadres", with: "qkunst-admin-user@murb.nl")
    fill_in("Wachtwoord", with: "password")
    first("#new_user input[type=submit]").click
    click_on "Collecties"
    click_on "Collection 1"
    click_on "Work1"
    click_on "Beheer tags"
    # expect(page).to have_content('bewerk')
    # first(".detailed_data table tr a").click
    # expect(page).to have_content('Bewerk locatie')
    # fill_in('Verdieping', with: 'Nieuwe verdieping')
    # click_on "Kunstwerk bewaren"
    # expect(page).to have_content('Nieuwe verdieping')
  end
end
