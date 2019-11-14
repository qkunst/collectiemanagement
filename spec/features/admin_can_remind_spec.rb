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
  end

  scenario "on a collection" do
    visit root_path
    first(".large-12.columns .button").click
    fill_in("E-mailadres", with: "qkunst-admin-user@murb.nl")
    fill_in("Wachtwoord", with: "password")
    first("#new_user input[type=submit]").click

    visit collection_reminders_path(Collection.first)
    expect(page).to have_content('Herinneringen')
  end

end

