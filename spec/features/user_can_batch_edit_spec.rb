# frozen_string_literal: true

require_relative "feature_helper"

RSpec.feature "Batch editor", type: :feature do
  include ActiveSupport::Testing::TimeHelpers
  include FeatureHelper

  scenario "facility manager can scan works with batch editor" do
    login "qkunst-test-facility_manager@murb.nl"

    click_on "Collecties"
    if page.body.match?("id=\"list-to-filter\"")
      within "#list-to-filter" do
        click_on "Collection 1"
      end
    end
    click_on "Toon alle 5 werken"
    click_on "Scan"
    fill_in "Inventarisnummers / alternatieve nummers (waaronder evt. barcodes) van aan te passen werken regel-gescheiden", with: [works(:work1), works(:work2)].map(&:stock_number).join("\n")

    fill_in_with_strategy(:location, "Nieuw adres", :REPLACE)
    fill_in_with_strategy(:location_floor, "Nieuwe verdieping", :REPLACE)
    fill_in_with_strategy(:location_detail, "Nieuwe locatie specificatie", :REPLACE)

    click_on "Werken bijwerken"
    expect(page.body).to match("De onderstaande 2 werken zijn bijgewerkt ")

    expect(works(:work1).reload.location).to eq("Nieuw adres")
    expect(works(:work2).reload.location).to eq("Nieuw adres")
    expect(works(:work1).location_floor).to eq("Nieuwe verdieping")
    expect(works(:work2).location_floor).to eq("Nieuwe verdieping")
    expect(works(:work1).location_detail).to eq("Nieuwe locatie specificatie")
    expect(works(:work2).location_detail).to eq("Nieuwe locatie specificatie")
  end

  scenario "move work to sub-collection in cluster" do
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
    work_to_edit3 = works(:work5)

    expect(work_to_edit1.cluster).not_to eq(work_to_edit2.cluster)

    check "selected_works_#{work_to_edit1.id}"
    check "selected_works_#{work_to_edit2.id}"
    click_on "Overige velden"

    new_cluster_name = "My first batch cluster"
    fill_in_with_strategy(:cluster_name, new_cluster_name, :REPLACE)
    click_on "2 werken bijwerken"

    work_to_edit1 = Work.find(work_to_edit1.id)
    work_to_edit2 = Work.find(work_to_edit2.id)

    expect(work_to_edit1.cluster).to eq(work_to_edit2.cluster)
    expect(work_to_edit1.cluster.name).to eq(new_cluster_name)

    within "#responsive-filter" do
      click_on "Reset filters"
    end
    check "selected_works_#{work_to_edit1.id}"
    check "selected_works_#{work_to_edit3.id}"
    click_on "Overige velden"

    fill_in_with_strategy(:cluster_name, new_cluster_name, :APPEND)
    click_on "2 werken bijwerken"

    work_to_edit1 = Work.find(work_to_edit1.id)
    work_to_edit3 = Work.find(work_to_edit3.id)

    expect(work_to_edit1.cluster.name).to eq("#{new_cluster_name} #{new_cluster_name}")
    expect(work_to_edit3.cluster.name).to eq("cluster2 #{new_cluster_name}")
  end

  scenario "appraise works" do
    travel 1.day do
      work_to_edit1 = works(:work1)
      work_to_edit2 = works(:work2)

      login "qkunst-test-appraiser@murb.nl"

      click_on "Collecties"
      if page.body.match?("id=\"list-to-filter\"")
        within "#list-to-filter" do
          click_on "Collection 1"
        end
      end
      click_on "Toon alle 5 werken"

      expect(work_to_edit1.cluster).not_to eq(work_to_edit2.cluster)

      check "selected_works_#{work_to_edit1.id}"
      check "selected_works_#{work_to_edit2.id}"
      click_on "Overige velden"
      select("100-200")
      fill_in("Gewaardeerd op", with: "")
      select(I18n.t("helpers.batch.strategies.REPLACE"), from: "work_appraisals_attributes_0_update_replacement_value_range_strategy")

      click_on "2 werken bijwerken"
      expect(page.body).to match("Gewaardeerd op moet opgegeven zijn")

      expect(work_to_edit1.appraisals.where(created_at: (5.minutes.ago..5.minutes.from_now)).count).to eq(0)
      expect(work_to_edit2.appraisals.where(created_at: (5.minutes.ago..5.minutes.from_now)).count).to eq(0)

      click_on "Collecties"
      if page.body.match?("id=\"list-to-filter\"")
        within "#list-to-filter" do
          click_on "Collection 1"
        end
      end
      click_on "Toon alle 5 werken"

      expect(work_to_edit1.cluster).not_to eq(work_to_edit2.cluster)

      check "selected_works_#{work_to_edit1.id}"
      check "selected_works_#{work_to_edit2.id}"
      click_on "Overige velden"
      select("100-200")
      select(I18n.t("helpers.batch.strategies.REPLACE"), from: "work_appraisals_attributes_0_update_market_value_range_strategy")
      fill_in("Gewaardeerd op", with: "2019-01-01")
      select(I18n.t("helpers.batch.strategies.REPLACE"), from: "work_appraisals_attributes_0_update_appraised_on_strategy")

      click_on "2 werken bijwerken"

      expect(page.body).to match("De onderstaande 2 werken zijn bijgewerkt")

      work_to_edit1 = Work.find(work_to_edit1.id)
      work_to_edit2 = Work.find(work_to_edit2.id)

      expect(work_to_edit1.appraisals.where(created_at: (5.minutes.ago..5.minutes.from_now)).count).to eq(1)
      expect(work_to_edit2.appraisals.where(created_at: (5.minutes.ago..5.minutes.from_now)).count).to eq(1)

      work_to_edit1.reload

      expect(work_to_edit1.market_value_range.min).to eq(100)
      expect(work_to_edit2.market_value_range.min).to eq(100)
      expect(work_to_edit1.market_value_range.max).to eq(200)
      expect(work_to_edit2.market_value_range.max).to eq(200)
    end
  end

  scenario "modify other attributes (happy flow)" do
    work_to_edit1 = works(:work1)
    work_to_edit2 = works(:work2)

    login "qkunst-test-appraiser@murb.nl"

    click_on "Collecties"
    if page.body.match?("id=\"list-to-filter\"")
      within "#list-to-filter" do
        click_on "Collection 1"
      end
    end
    click_on "Toon alle 5 werken"

    check "selected_works_#{work_to_edit1.id}"
    check "selected_works_#{work_to_edit2.id}"
    click_on "Overige velden"

    new_values = {
      location: "New location",
      minimum_bid: 0.12,
      selling_price: 12345.01,
      purchase_price: 853.41,
      purchased_on: "2012-05-03".to_date
    }

    new_values.each do |key, value|
      fill_in_with_strategy(key, value, :REPLACE)
    end

    click_on "2 werken bijwerken"

    work_to_edit1.reload

    new_values.each do |key, value|
      expect(work_to_edit1.send(key)).to eq(value)
    end
  end

  describe "Specialized batch editors" do
    scenario "move work to subcollection in using the cluster-batch editor" do
      login "qkunst-test-advisor@murb.nl"

      click_on "Collecties"
      if page.body.match?("id=\"list-to-filter\"")
        within "#list-to-filter" do
          click_on "Collection 1"
        end
      end
      click_on "Toon alle 5 werken"
      work_to_add_to_cluster = works(:work1)

      check "selected_works_#{work_to_add_to_cluster.id}"
      click_on "Cluster"
      fill_in_with_strategy(:cluster_name, "My first batch cluster", :REPLACE)
      click_on "1 werk bijwerken"
      check "selected_works_#{work_to_add_to_cluster.id}"
      click_on "Collectie"
      select "Collection with works child (sub of Collection 1 >> colection with works)"
      select "⇆ Vervang"
      click_on "1 werk bijwerken"
      click_on "Work1"
      expect(page).to have_content("Collection with works child (sub of Collection 1 >> colection with works)")
      expect(page).to have_content("My first batch cluster")
    end
  end

  def fill_in_with_strategy field, value, strategy = IGNORE
    fill_in(I18n.t("activerecord.attributes.work.#{field}"), with: value)
    select(I18n.t("helpers.batch.strategies.#{strategy}"), from: "work_update_#{field}_strategy")
  end
end
