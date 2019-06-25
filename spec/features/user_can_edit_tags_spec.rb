# frozen_string_literal: true

require 'rails_helper'

RSpec.feature "UserCanEditTags", type: :feature do
  ["qkunst-regular-withcollection-user@murb.nl", "qkunst-admin-user@murb.nl", "qkunst-test-appraiser@murb.nl", "qkunst-test-advisor@murb.nl"].each do |email_address|
    context email_address do
      scenario "can edit tags" do
        visit root_path
        first(".large-12.columns .button").click
        fill_in("E-mailadres", with: email_address)
        fill_in("Wachtwoord", with: "password")
        first("#new_user input[type=submit]").click
        click_on "Collecties"
        click_on "Collection 1"
        click_on "Work1"
        click_on "Beheer tags"
        expect(page).to have_content('bewerk')
        click_on "Kunstwerk bewaren"
        work1 = works(:work1)
        work1.tag_list = ["tagboter", "tagkaas"]
        work1.save
        click_on "Beheer tags"
        unselect "tagboter", from: "works_tags"
        click_on "Kunstwerk bewaren"
        expect(page).to have_content("tagkaas")
        expect(page).not_to have_content("tagboter")
        click_on "Beheer tags"
        unselect "tagkaas", from: "works_tags"
        click_on "Kunstwerk bewaren"
        expect(page).not_to have_content("tagkaas")
        expect(page).not_to have_content("tagboter")
      end
    end
  end
end