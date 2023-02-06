# frozen_string_literal: true

require_relative "feature_helper"

RSpec.feature "Werken groeperen", type: :feature do
  include FeatureHelper

  scenario "Advisor can group works" do
    login "qkunst-test-advisor@murb.nl"

    click_on "Collecties"
    if page.body.match?("id=\"collections-list\"")
      within "#collections-list" do
        click_on "Collection 1"
      end
    end
    click_on "Toon alle 5 werken"

    work_to_edit1 = works(:work1)
    work_to_edit2 = works(:work2)

    check "selected_works_#{work_to_edit1.id}"
    check "selected_works_#{work_to_edit2.id}"

    click_on "Groepeer"

    select "Meerluik"
    fill_in "Identificatiecode", with: "123"
    click_on "Werkgroepering toevoegen"

    expect(page.body).to match(work_to_edit1.stock_number)
    expect(page.body).to match(work_to_edit2.stock_number)
    expect(page.body).to match("Meerluik - 123")
  end

  scenario "Advisor add a work to an existing group" do
    login "qkunst-test-advisor@murb.nl"

    click_on "Collecties"
    if page.body.match?("id=\"collections-list\"")
      within "#collections-list" do
        click_on "Collection 1"
      end
    end
    click_on "Toon alle 5 werken"

    work_to_edit1 = works(:work1)
    work_to_edit2 = works(:work2)

    check "selected_works_#{work_to_edit1.id}"

    click_on "Groepeer"

    select "Meerluik"
    fill_in "Identificatiecode", with: "123"
    click_on "Werkgroepering toevoegen"

    expect(page.body).to match(work_to_edit1.stock_number)
    expect(page.body).not_to match(work_to_edit2.stock_number)

    expect(page.body).to match("Meerluik - 123")

    visit collection_works_path(collections(:collection1))
    check "selected_works_#{work_to_edit2.id}"

    click_on "Groepeer"
    select "Meerluik - 123"
    click_on "Toevoegen"
    expect(page.body).to match(work_to_edit1.stock_number)
    expect(page.body).to match(work_to_edit2.stock_number)
  end

  scenario "Admin can remove a work from a group" do
    login "qkunst-admin-user@murb.nl"

    visit collection_work_set_path(work_sets(:random_other_collection).works.first.collection, work_sets(:random_other_collection))

    within(".panel.work:first-of-type") do
      click_on "⨯"
    end
    expect(page.body).to match(/Het werk Work[6|7] is verwijderd uit deze groepering./)
  end
end
