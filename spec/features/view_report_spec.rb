# frozen_string_literal: true

require_relative 'feature_helper'

RSpec.feature "View report spec", type: :feature do
  include FeatureHelper

  scenario "view a collection report" do
    begin
      Work.__elasticsearch__.delete_index!
    rescue Elasticsearch::Transport::Transport::Errors::NotFound
    end
    Work.__elasticsearch__.create_index! force: true

    login "qkunst-admin-user@murb.nl"

    visit collections_path

    click_on('Collection 1')

    within "#responsive-menu" do

      click_on("Rapportage")

    end

    expect(page).not_to have_content("cluster1")
    expect(page).not_to have_content("Room 1")

    click_on("Ververs rapportage")

    expect(page).to have_content("Room 1")
    expect(page).to have_content("Floor 1")
    expect(page).to have_content("Adres")
    expect(page).to have_content("Formaatcode onbekend2 l1")

    click_on("cluster1")

    expect(page).to have_content("Deze (gefilterde) collectie bevat 1 werk (van de 3 werken)")
    expect(page).to have_content("Q001")

    signout

    login users(:facility_manager)

    visit collections_path

    within "#responsive-menu" do

      click_on("Rapportage")

    end

    expect(page).not_to have_content("cluster1")
    expect(page).not_to have_content("Marktwaarde")

    expect(page).to have_content("Room 1")
    expect(page).to have_content("Floor 1")
    expect(page).to have_content("Adres")
  end

end

