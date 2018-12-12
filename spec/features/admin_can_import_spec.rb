require 'rails_helper'

RSpec.feature "UserCanEditPhotos", type: :feature do
  # include Devise::Test::IntegrationHelpers
  scenario ":qkunst_with_collection" do
    # sign_in# (:admin)
    visit root_path
    first(".large-12.columns .button").click
    fill_in("E-mailadres", with: "qkunst-admin-user@murb.nl")
    fill_in("Wachtwoord", with: "password")
    first("#new_user input[type=submit]").click
    click_on "Collecties"
    click_on "Collection 3"
    click_on "Beheer"
    click_on "Import"
    click_on "Nieuwe import"
    attach_file "Importbestand", File.join(Rails.root,"spec","fixtures","import_collection_file.csv")
    click_on "Import toevoegen"
    expect(page).to have_content('artist_name')
    expect(page).to have_content('work_title')
    first("input[value='Import bewaren']").click
    expect(page).to have_content('Nog geen titel')
    save_and_open_page
  end
end