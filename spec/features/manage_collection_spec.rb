# frozen_string_literal: true

require_relative 'feature_helper'

RSpec.feature "Manage Collection", type: :feature do
  include FeatureHelper

  context "as admin" do
    before(:each) do
      login "qkunst-admin-user@murb.nl"

      visit collections_path

      click_on('Collection 1')
    end

    scenario "editing a collection" do
      click_on('Bewerk gegevens')

      fill_in "Toelichting bij collectie", with: "Gewoon een toelichting"
      fill_in "Naam", with: "Collection 1 adjusted"
      fill_in "Label voor alternatief nummer 1", with: "Barcode"
      click_on "Collectie bewaren"

      expect(page).to have_content "Gewoon een toelichting"
      expect(page).to have_content "Collection 1 adjusted"
    end


    scenario "creating a sub-collection" do
      click_on('Voeg nieuwe subcollectie voor deze collectie toe')

      fill_in "Toelichting bij collectie", with: "Toelichting bij sub"
      fill_in "Naam", with: "Collection 1 sub"
      click_on "Collectie toevoegen"

      expect(page).to have_content "Toelichting bij sub"
      expect(page).to have_content "Collection 1 sub"
      expect(page).to have_content "Maakt deel uit van: Collection 1"
    end
  end
end

