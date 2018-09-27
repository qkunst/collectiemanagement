require 'rails_helper'

RSpec.feature "UserCanEditPhotos", type: :feature do
  # include Devise::Test::IntegrationHelpers
  scenario ":qkunst_with_collection" do
    # sign_in# (:admin)
    visit root_path
    first(".large-12.columns .button").click
    fill_in("E-mailadres", with: "qkunst-regular-withcollection-user@murb.nl")
    fill_in("Wachtwoord", with: "password")
    first("#new_user input[type=submit]").click
    # click_on "Collecties"

    visit collection_url(collections(:collection1))
    # expect(page).to have_content("asdf")
    # click_on "Werken"
    click_on "Work1"
    click_on "Voeg foto’s toe"
    attach_file "Foto voorkant", File.expand_path('../fixtures/image.jpg', __dir__)
    click_on "Kunstwerk bewaren"
    click_on "Beheer foto's"
    # expect(page).to have_content('bewerk')
    # first(".detailed_data table tr a").click
    # expect(page).to have_content('Bewerk locatie')
    # fill_in('Verdieping', with: 'Nieuwe verdieping')
    # click_on "Kunstwerk bewaren"
    # expect(page).to have_content('Nieuwe verdieping')
  end
end
