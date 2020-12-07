# frozen_string_literal: true

require_relative "feature_helper"

RSpec.feature "Werken groeperen", type: :feature do
  include FeatureHelper

  scenario "Advisor can group works" do
    login "qkunst-test-advisor@murb.nl"

    click_on "Collecties"
    if page.body.match?("id=\"list-to-filter\"")
      within "#list-to-filter" do
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
    fill_in "Identificatienummer", with: "123"
    click_on "Werkgroepering toevoegen"

    expect(page.body).to match(work_to_edit1.stock_number)
    expect(page.body).to match(work_to_edit2.stock_number)
    expect(page.body).to match("Meerluik - 123")
  end
end
