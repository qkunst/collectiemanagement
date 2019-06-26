# frozen_string_literal: true

require 'rails_helper'

RSpec.feature "AdvisorCanPartlyManageAttachments", type: :feature do
  context Collection do
    scenario "manage attachments" do
      # sign_in# (:admin)
      visit root_path
      first(".large-12.columns .button").click
      fill_in("E-mailadres", with: "qkunst-test-advisor@murb.nl")
      fill_in("Wachtwoord", with: "password")
      first("#new_user input[type=submit]").click
      click_on "Collecties"
      click_on "Collection 1"
      click_on "Bijlage toevoegen"
      attach_file "Bestand", File.expand_path('../fixtures/image.jpg', __dir__)
      fill_in("Bestandsnaam / beschrijving", with: "Image1.jpg")
      check("Registrator")
      click_on "Bijlage toevoegen"
      expect(page).to have_content('Attachment toegevoegd')
      expect(page).to have_content('Image1.jpg')
      click_on "Beheer bijlagen"
      expect(page).to have_content('Image1.jpg')
      # expect(page).to have_content "Bewerk bijlage"
      click_on "Bewerk"
      fill_in("Bestandsnaam / beschrijving", with: "Image1 beperkt.jpg")

      click_on "Bijlage bewaren"
      expect(page).to have_content('Attachment bijgewerkt')
      expect(page).to have_content("Image1 beperkt.jpg")
    end
  end
  context Work do
    scenario "manage attachments" do
      # sign_in# (:admin)
      visit root_path
      first(".large-12.columns .button").click
      fill_in("E-mailadres", with: "qkunst-test-advisor@murb.nl")
      fill_in("Wachtwoord", with: "password")
      first("#new_user input[type=submit]").click
      click_on "Collecties"
      click_on "Collection 1"
      click_on "Work1"

      click_on "Bijlage toevoegen"
      attach_file "Bestand", File.expand_path('../fixtures/image.jpg', __dir__)
      fill_in("Bestandsnaam / beschrijving", with: "Image1.jpg")
      check("Registrator")
      click_on "Bijlage toevoegen"
      expect(page).to have_content('Attachment toegevoegd')
      expect(page).to have_content('Image1.jpg')
      click_on "Beheer bijlagen"
      expect(page).to have_content('Image1.jpg')
      click_on "Bewerk"
      fill_in("Bestandsnaam / beschrijving", with: "Image1 beperkt.jpg")

      click_on "Bijlage bewaren"
      expect(page).to have_content('Attachment bijgewerkt')
      expect(page).to have_content("Dit werk heeft nog geen foto's")
      expect(page).to have_content("Image1 beperkt.jpg")
    end
  end
end