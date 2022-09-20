# frozen_string_literal: true

require_relative "feature_helper"

RSpec.feature "Edit photos", type: :feature do
  extend FeatureHelper
  include FeatureHelper

  ["qkunst-regular-user-with-collection@murb.nl", "qkunst-admin-user@murb.nl", "qkunst-test-appraiser@murb.nl", "qkunst-test-advisor@murb.nl"].each do |email_address|
    context email_to_role(email_address) do
      scenario "can edit photo's" do
        allow_any_instance_of(PictureUploader).to receive(:resize_to_fit)
        allow_any_instance_of(PictureUploader).to receive(:optimize)

        login email_address

        visit collection_url(collections(:collection1))

        click_on "Work1"
        click_on "Voeg foto’s toe"
        attach_file "Foto voorkant", File.expand_path("../fixtures/files/image.jpg", __dir__)
        click_on "Werk bewaren"
        click_on "Beheer foto's"

        expect(page).to have_content("Beheer foto's van Q001 Work1")
        click_on "Werk bewaren"
      end
    end
  end
  ["qkunst-test-read_only@murb.nl", "qkunst-test-compliance@murb.nl"].each do |email_address|
    context email_to_role(email_address) do
      scenario "can not edit photo's" do
        login email_address

        visit collection_url(collections(:collection1))

        click_on "Work1"

        expect(page).not_to have_content "Voeg foto’s toe"

        visit collection_work_edit_photos_path(works(:work1).collection, works(:work1))
        expect(page).not_to have_content("Beheer foto's van Q001 artist_1")
        expect(page).to have_content("Alleen medewerkers van #{I18n.t("organisation.name")} kunnen deze pagina bekijken")
      end
    end
  end
end
