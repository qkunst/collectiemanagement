# frozen_string_literal: true

require_relative "feature_helper"

RSpec.feature "User can send messages", type: :feature do
  include FeatureHelper

  ["qkunst-test-facility_manager@murb.nl", "qkunst-admin-user@murb.nl", "qkunst-test-appraiser@murb.nl", "qkunst-test-advisor@murb.nl", "qkunst-test-compliance@murb.nl"].each do |email_address|
    context email_address do
      scenario "can send messages" do
        login email_address

        click_on "Collecties"

        if page.body.match?("id=\"list-to-filter\"")
          within "#list-to-filter" do
            click_on "Collection 1"
          end
        end

        expect(body).to match "Vraag of opmerking?"

        click_on "Vraag of opmerking?"

        fill_in "Onderwerp", with: "Ondewerp #{email_address}"
        fill_in "Berichttekst", with: "Berichttekst"

        expect {
          click_on "Bericht versturen"
        }.to change(ActionMailer::Base.deliveries, :count).by(email_address == "qkunst-admin-user@murb.nl" ? 2 : 3)

        expect(page).to have_content("Uw bericht is verstuurd")

        click_on "Berichten"

        expect(page).to have_content("Ondewerp #{email_address}")

        click_on "Ondewerp #{email_address}"

        expect(page).to have_content "Ondewerp #{email_address}"

        click_on "Uitloggen"

        login "qkunst-admin-user@murb.nl"

        click_on "Berichten"
        click_on "Ondewerp #{email_address}"

        fill_in "Berichttekst", with: "Antwoord op bericht van #{email_address}"

        expect {
          click_on "Bericht versturen"
        }.to change(ActionMailer::Base.deliveries, :count).by(email_address == "qkunst-admin-user@murb.nl" ? 2 : 3)

        click_on "Uitloggen"

        login email_address

        click_on "Berichten"

        click_on "Ondewerp #{email_address}"

        expect(page).to have_content "Antwoord op bericht van #{email_address}"

        click_on "Uitloggen"

        login "qkunst-admin-user@murb.nl"

        click_on "Berichten"
        click_on "Ondewerp #{email_address}"

        expect {
          click_on "Markeer conversatie als afgerond"
        }.to change(Message.where(actioned_upon_by_qkunst_admin_at: nil), :count).by(-1)
      end
    end
  end
end
