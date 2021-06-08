# frozen_string_literal: true

require_relative "feature_helper"

RSpec.feature "User can send messages", type: :feature do
  include FeatureHelper

  scenario "can mark message as completed" do
    login "qkunst-admin-user@murb.nl"

    visit message_path(messages(:old_message))

    expect {
      click_on "Markeer conversatie als afgerond"
    }.to change(Message.where(actioned_upon_by_qkunst_admin_at: nil), :count).by(-1)
  end

  ["qkunst-test-facility_manager@murb.nl", "qkunst-admin-user@murb.nl", "qkunst-test-appraiser@murb.nl", "qkunst-test-advisor@murb.nl", "qkunst-test-compliance@murb.nl"].each do |email_address|
    context email_address do
      scenario "can send messages" do
        login email_address

        click_on "Collecties"

        if page.body.match?("id=\"collections-list\"")
          within "#collections-list" do
            click_on "Collection 1"
          end
        end

        expect(body).to match "Vraag of opmerking?"

        click_on "Vraag of opmerking?"

        subject = "Ondewerp #{email_address} #{SecureRandom.uuid}"

        fill_in "Onderwerp", with: subject
        fill_in "Berichttekst", with: "Berichttekst"

        expect {
          click_on "Bericht versturen"
        }.to change(ActionMailer::Base.deliveries, :count).by(email_address == "qkunst-admin-user@murb.nl" ? 1 : 2)

        message = Message.find_by_subject(subject)
        expect(message.actioned_upon_by_qkunst_admin?).to eq(false)

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
        }.to change(ActionMailer::Base.deliveries, :count).by(email_address == "qkunst-admin-user@murb.nl" ? 1 : 2)

        message.reload
        expect(message.actioned_upon_by_qkunst_admin?).to eq(true)

        click_on "Uitloggen"

        login email_address

        click_on "Berichten"

        click_on "Ondewerp #{email_address}"

        expect(page).to have_content "Antwoord op bericht van #{email_address}"
      end
    end
  end
end
