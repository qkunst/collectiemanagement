# frozen_string_literal: true

require 'rails_helper'

RSpec.feature "Import works", type: :feature do
  scenario "as an admin from CSV" do
    visit root_path
    first(".large-12.columns .button").click
    fill_in("E-mailadres", with: "qkunst-admin-user@murb.nl")
    fill_in("Wachtwoord", with: "password")
    first("#new_user input[type=submit]").click
    click_on "Collecties"
    if page.body.match("id=\"list-to-filter\"")
      within "#list-to-filter" do
        click_on "Collection 3"
      end
    end
    within "#responsive-menu" do
      click_on "Beheer"
    end
    click_on "Import"
    click_on "Nieuwe import"
    attach_file "Importbestand", File.join(Rails.root,"spec","fixtures","import_collection_file.csv")
    click_on "Import toevoegen"
    expect(page).to have_content('artist_name')
    expect(page).to have_content('work_title')
    first("input[value='Import bewaren']").click
    expect(page).to have_content('Nog geen titel')
    click_on("Bewerk de importinstellingen")
    first('select[name="[import_settings][stock_number][fields][]"] option[value="work.stock_number"]').select_option
    first('select[name="[import_settings][artist_name][fields][]"] option[value="artists.last_name"]').select_option
    first('select[name="[import_settings][work_title][fields][]"] option[value="work.title"]').select_option
    first('select[name="[import_settings][drager][fields][]"] option[value="work.medium"]').select_option
    first('select[name="[import_settings][niveau][fields][]"] option[value="work.grade_within_collection"]').select_option
    first("[value='Import bewaren']").click
    click_on "Importeer de werken"
    expect(page).to have_content("De werken zijn geïmporeerd.")
  end

  scenario "and upload matching images" do
    visit root_path
    first(".large-12.columns .button").click
    fill_in("E-mailadres", with: "qkunst-admin-user@murb.nl")
    fill_in("Wachtwoord", with: "password")
    first("#new_user input[type=submit]").click
    click_on "Collecties"
    if page.body.match("id=\"list-to-filter\"")
      within "#list-to-filter" do
        click_on "Collection 1"
      end
    end
    within "#responsive-menu" do
      click_on "Beheer"
    end
    click_on "Import"
    click_on "Nieuwe set aan foto's uploaden"
    files = ["Q001", "Q005", "Q006", "Qna"].map{|a| File.join(Rails.root,"spec","fixtures","batch_photo_upload","#{a}.jpg")}
    attach_file "Afbeeldingen", files, multiple: true
    click_on "Foto-import toevoegen"
    expect(page).to have_content("Work1")
    expect(page).to have_content("Work5")
    expect(page).not_to have_content("Work6") #work from another collection
    batch_photo_upload = BatchPhotoUpload.find(page.current_url.split("/").last.to_i)

    expect(CouplePhotosWorker).to receive(:perform_async).exactly(1).times.with(batch_photo_upload.id)

    click_on("kan deze definitief gemaakt worden")
    expect(page).to have_content("De foto's worden op de achtergrond aan de werken gekoppeld")

  end

end

