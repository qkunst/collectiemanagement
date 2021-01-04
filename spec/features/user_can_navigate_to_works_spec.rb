# frozen_string_literal: true

require_relative "feature_helper"

RSpec.feature "Navigate works in a collection", type: :feature do
  include FeatureHelper
  extend FeatureHelper

  ["qkunst-test-read_only@murb.nl", "qkunst-test-compliance@murb.nl"].each do |email_address|
    context email_to_role(email_address) do
      scenario "cannot edit anything" do
        visit root_path
        expect(page).to have_content("QKunst Collectiemanagement")
        expect(page).to have_content("Welkom")

        login email_address

        expect(page).to have_content("Succesvol ingelogd")
        expect(page).to have_content("Ingelogd als #{email_address}")
        click_on "Collecties"
        expect(page).to have_content("Ingelogd als #{email_address}")
        expect(page).to have_content("Collection 1")
        expect(page).not_to have_content("+ Voeg werk toe")
        expect(page).not_to have_content("Bewerk")
        expect(page).to have_content("Doorzoek de werken")
        within "#responsive-menu" do
          click_on "Werken"
        end
        expect(page).to have_content(/Deze collectie bevat \d werken/)
        expect(page).not_to have_content("Bewerk")
        click_on "Work1"
        expect(page).to have_content("Details")
        expect(page).not_to have_content("Bewerk")
      end
    end
  end
  ["qkunst-regular-user-with-collection@murb.nl", "qkunst-admin-user@murb.nl", "qkunst-test-appraiser@murb.nl", "qkunst-test-advisor@murb.nl"].each do |email_address|
    context email_to_role(email_address) do
      scenario "can edit work through main form" do
        login email_address

        expect(page).to have_content(/Succesvol (ingelogd|geautoriseerd)/)
        expect(page).to have_content("Ingelogd als #{email_address}")
        click_on "Collecties"
        expect(page).to have_content("Collection 1")

        click_on "Collection 1" if ["qkunst-admin-user@murb.nl", "qkunst-test-appraiser@murb.nl"].include? email_address

        expect(page).to have_content("Doorzoek de werken")
        within "#responsive-menu" do
          click_on "Werken"
        end
        expect(page).to have_content(/Deze collectie bevat \d werken/)
        expect(page).to have_content("Deelcollectie")
        expect(page).to have_content("Herkomst")
        click_on "Work1"
        expect(page).to have_content("Details")
        expect(page).to have_content("Q001")
        first(".bottom-nav a.primary").click
        fill_in("Adres en/of gebouw(deel)", with: "Grotestraat 1")
        check("Na bewaren direct de volgende bewerken")
        click_on "Werk bewaren"
        fill_in("Adres en/of gebouw(deel)", with: "Grotestraat 2")
        click_on "Werk bewaren"
        expect(page).to have_content("Q002")
        expect(page).to have_content("Het werk is bijgewerkt")
        expect(page).to have_content("Grotestraat 2")
        click_on "◀"
        expect(page).to have_content("Q001")
        expect(page).to have_content("Grotestraat 1")
        first(".detailed_data table tr a").click
        fill_in("Verdieping", with: "vurdiepB")
        click_on "Werk bewaren"
        expect(page).to have_content("Het werk is bijgewerkt")
        expect(page).to have_content("Verdieping:vurdiepB")
      end
    end
  end

  ["qkunst-regular-user-with-collection@murb.nl", "qkunst-admin-user@murb.nl", "qkunst-test-appraiser@murb.nl", "qkunst-test-advisor@murb.nl", "qkunst-test-facility_manager@murb.nl"].each do |email_address|
    context email_to_role(email_address) do
      scenario "can edit location through location form" do
        login email_address

        expect(page).to have_content(/Succesvol (ingelogd|geautoriseerd)/)
        expect(page).to have_content("Ingelogd als #{email_address}")
        click_on "Collecties"
        expect(page).to have_content("Collection 1")

        click_on "Collection 1" if ["qkunst-admin-user@murb.nl", "qkunst-test-appraiser@murb.nl"].include? email_address
        click_on "Work1"
        expect(page).not_to have_content("Bewerk gegevens") unless ["qkunst-regular-user-with-collection@murb.nl", "qkunst-admin-user@murb.nl", "qkunst-test-appraiser@murb.nl", "qkunst-test-advisor@murb.nl"].include?(email_address)
        expect(page).to have_content("Bewerk")
        first(".detailed_data table tr a").click
        expect(page).to have_content("Bewerk locatie")
        fill_in("Verdieping", with: "Nieuwe verdieping")
        click_on "Werk bewaren"
        expect(page).to have_content("Nieuwe verdieping")
      end
    end
  end
end
