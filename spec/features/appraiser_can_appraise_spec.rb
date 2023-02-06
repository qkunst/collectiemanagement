# frozen_string_literal: true

require_relative "feature_helper"

RSpec.feature "Appraise works", type: :feature do
  include FeatureHelper

  context "as appraiser" do
    before(:each) do
      login "qkunst-test-appraiser@murb.nl"
    end
    it "cannot appraise work outside scope" do
      work = works(:work_with_private_theme)
      expect {
        visit collection_work_path(work.collection, work)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "can appraise work using ranges" do
      work = works(:work1)

      visit collection_work_path(work.collection, work)
      click_on "Waardeer"

      select "100-200"
      select "250-500"
      fill_in "Referentie", with: "Waarderingsreferentie van nu"

      fill_in "Aankoopjaar", with: 1962
      fill_in "Aankoopprijs", with: 1000
      select "NLG (𝑓)"
      select "BKR"
      fill_in "Herkomst opmerkingen", with: "Herkomstopmerkingen van nu"

      select "B"
      check "Kerncollectie"
      select "Owner1"
      check "Oplage onbekend"

      fill_in "Overige opmerkingen", with: "Overige opmerkingen van nu"

      click_on "Waardering toevoegen"

      expect(page).to have_content "€100,00-€200,00"
      expect(page).to have_content "€250,00-€500,00"
      expect(page).to have_content "1962"
      expect(page).to have_content "𝑓1.000,00"
      expect(page).to have_content "Owner1"
      expect(page).to have_content "Kerncollectie:Ja"
      expect(page).to have_content "Niveau binnen collectie:B"
      expect(page).to have_content "Overige opmerkingen van nu"
      expect(page).to have_content "Herkomstopmerkingen van nu"
      expect(page).to have_content "Oplage:Onbekend"

      click_on "Waardeer"
      expect(page).to have_content "€100,00-€200,00"
      expect(page).to have_content "Waarderingsreferentie van nu"
    end

    it "cannot appraise a diptych at work level, but only at work set level" do
      work = works(:work_diptych_1)
      visit collection_work_path(work.collection, work)
      click_on "Waardeer"
      click_on "Open het Meerluik om te waarderen"
      click_on "Waardeer"
      fill_in "Marktwaarde (€)", with: 234
      fill_in "Vervangingswaarde (€)", with: 567

      click_on "Waardering toevoegen"
      click_on "QDT2a"
      expect(page).to have_content "Waardering voor gehele Meerluik"
      expect(page).to have_content "€234"
      expect(page).to have_content "€567"
    end

    it "can appraise work old style" do
      work = works(:work6)
      visit collection_work_path(work.collection, work)
      click_on "Waardeer"

      fill_in "Marktwaarde (€)", with: 234
      fill_in "Vervangingswaarde (€)", with: 567

      click_on "Waardering toevoegen"

      expect(page).not_to have_content "Waardering voor gehele Meerluik"
      expect(page).to have_content "€234"
      expect(page).to have_content "€567"
    end
  end
end
