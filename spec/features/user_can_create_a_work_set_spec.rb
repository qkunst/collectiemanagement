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

  scenario "Admin can start a time span for a group" do
    login "qkunst-admin-user@murb.nl"

    work_set = work_sets(:available_works)
    collection = work_sets(:available_works).works.first.collection
    first_work = work_sets(:available_works).works.first

    visit collection_work_set_path(collection, work_set)

    expect(work_sets(:available_works).works.first).to be_available
    expect(work_sets(:available_works).works.last).to be_available

    click_on "Start gebeurtenis"
    choose "Verhuur"
    choose "Actief"
    click_on "Gebeurtenis toevoegen"

    expect(work_sets(:available_works).works.first).not_to be_available
    expect(work_sets(:available_works).works.last).not_to be_available

    additional_work = works(:collection_with_availability_available_work_not_in_set)
    expect(additional_work).to be_available

    visit collection_works_path(collection, params: {ids: additional_work.id})

    within(".work .work-selector") do
      check "selected_works[]"
    end
    click_on "Groepeer"
    select "Other group"
    click_on "Toevoegen"

    expect(page.body).to match "Er is een gebeurtenis actief:"

    additional_work.reload

    expect(additional_work).not_to be_available

    click_on("QDT2e")
    click_on("Gebeurtenissen")
    click_on("Actief")
    click_on("Beëindig")

    additional_work = Work.find(additional_work.id)

    expect(additional_work).to be_available

    visit collection_work_set_path(collection, work_set)

    expect(page.body).to match "QDT2e"
    # timespans are connected
    expect(first_work.current_active_time_span.time_span).to eq(work_set.current_active_time_span)

    within "form[action=\"/work_sets/#{work_set.id}/works/#{first_work.id}\"]" do
      click_on "⨯"
    end

    expect(page.body).to match "Het werk Available is verwijderd uit de groepering"
    expect(page.body).to match "Let op: de actieve gebeurtenis is niet beëindigd"

    first_work = Work.find(first_work.id)
    expect(first_work).not_to be_available

    expect(first_work.current_active_time_span.time_span).to eq(nil)
  end
end
