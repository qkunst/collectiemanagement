# frozen_string_literal: true

require_relative "feature_helper"

RSpec.feature "View report", type: :feature, requires_elasticsearch: true do
  include FeatureHelper

  scenario "as an admin" do
    login "qkunst-admin-user@murb.nl"

    # required for TravisCI
    collections(:collection1).works_including_child_works.all.reindex!

    visit collections_path

    click_on("Collection 1")

    within "#responsive-menu" do
      click_on("Rapportage")
    end

    visit collection_manage_path(collections(:collection1))

    click_on("Ververs rapportage")

    expect(page).to have_content("Room 1")
    expect(page).to have_content("Floor 1")
    expect(page).to have_content("Adres")
    expect(page).to have_content("Formaatcode onbekend4 L1")

    click_on("Abstract")

    expect(page).to have_content("Deze collectie bevat 5 werken. Er wordt vanwege een filter 1 werk getoond.")
    expect(page).to have_content("Q001")

    within "#responsive-menu" do
      click_on("Rapportage")
    end

    click_on "Geïnventariseerd"

    expect(page).to have_content("Deze collectie bevat 5 werken. Er worden vanwege een filter 2 werken getoond.")
    expect(page).to have_content("Q001")
  end

  scenario "multi select" do
    login "qkunst-admin-user@murb.nl"

    # required for TravisCI
    collections(:collection1).works_including_child_works.all.reindex!

    visit collections_path

    click_on("Collection 1")

    within "#responsive-menu" do
      click_on("Rapportage")
    end

    visit collection_manage_path(collections(:collection1))
    click_on("Ververs rapportage")

    theme = Theme.find_by_name("wind").id
    first('[name="filter[themes.id][]"][value=not_set]').check
    first("[name=\"filter[themes.id][]\"][value=\"#{theme}\"]").check

    click_on("Werk aantallen selectie in rapportage bij")

    expect(page).to have_content("Deze collectie bevat 5 werken. In de rapportage wordt geteld op basis van onderdelen.")

    first("[name=\"filter[themes.id][]\"][value=\"#{theme}\"]").uncheck

    theme = Theme.find_by_name("earth").id

    first("[name=\"filter[themes.id][]\"][value=\"#{theme}\"]").check
    click_on("Werk aantallen selectie in rapportage bij")

    expect(page).to have_content("Deze collectie bevat 5 werken. Er wordt vanwege een filter gerapporteerd over 4 werken.")
  end

  scenario "as a facility manager (limited)" do
    # required for TravisCI
    collections(:collection1).works_including_child_works.all.reindex!

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

  scenario "as a facility manager support (limited)" do
    # required for TravisCI
    collections(:collection1).works_including_child_works.all.reindex!

    login users(:facility_manager_support)

    visit collections_path

    within "#responsive-menu" do
      click_on("Rapportage")
    end

    expect(page).to have_content("cluster1")
    expect(page).not_to have_content("Marktwaarde")

    expect(page).to have_content("Room 1")
    expect(page).to have_content("Floor 1")
    expect(page).to have_content("Adres")
  end
end
