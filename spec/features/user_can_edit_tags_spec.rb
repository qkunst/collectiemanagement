# frozen_string_literal: true

require_relative "feature_helper"

RSpec.feature "Edit tags", type: :feature do
  include FeatureHelper
  extend FeatureHelper

  ["qkunst-regular-user-with-collection@murb.nl", "qkunst-admin-user@murb.nl", "qkunst-test-appraiser@murb.nl", "qkunst-test-advisor@murb.nl"].each do |email_address|
    context email_to_role(email_address) do
      scenario "can edit tags" do
        login(email_address)

        click_on "Collecties"

        if page.body.match?("id=\"collections-list\"")
          within "#collections-list" do
            click_on "Collection 1"
          end
        end

        click_on "Work1"
        click_on "Beheer tags"
        expect(page).to have_content("bewerk")
        click_on "Werk bewaren"
        work1 = works(:work1)
        work1.tag_list = ["tagboter", "tagkaas"]
        work1.save
        click_on "Beheer tags"
        unselect "tagboter", from: "works_tags"
        click_on "Werk bewaren"
        expect(page).to have_content("tagkaas")
        expect(page).not_to have_content("tagboter")
        click_on "Beheer tags"
        unselect "tagkaas", from: "works_tags"
        click_on "Werk bewaren"
        expect(page).not_to have_content("tagkaas")
        expect(page).not_to have_content("tagboter")
      end
    end
  end
end
