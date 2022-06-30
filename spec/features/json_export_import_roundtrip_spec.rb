# frozen_string_literal: true

require_relative "feature_helper"

RSpec.feature "Manage Collection", type: :feature do
  include FeatureHelper

  def download_json(collection)
    visit api_v1_collection_works_path(collection, format: :json)
    filename = File.join(Rails.root, "tmp", "#{SecureRandom.uuid}.json")
    File.write(filename, page.body.gsub("\"id\":", "\"id\":99"))
    filename
  end

  context "as admin" do
    before(:each) do
      login "qkunst-admin-user@murb.nl"

    end

    it "should open imports overview" do
      target_collection = collections(:boring_collection)
      source_collection = collections(:collection1)
      appraisals(:appraisal_without_date).destroy
      file = download_json(source_collection)

      json = JSON.parse(File.read(file))
      json_artists = json["data"].find{|a| a["id"] == "99#{works(:work1).id}".to_i}["artists"]

      visit new_collection_import_collection_url(target_collection)
      # expect(page).to have_content "Aantal geïmporteerde werken"

      attach_file "Importbestand", file
      click_on "Import toevoegen"
      Sidekiq::Testing.inline! do
        click_on "Importeren"
      end
      expect(page).to have_content "De werken worden op de achtergrond geïmporteerd."
      expect((source_collection).works_including_child_works.count).to eq(5)
      expect((target_collection).works_including_child_works.count).to eq(5)

      # content check
      expect(works(:work1).tag_list).to eq(["Eerste tag fixture"])
      source_collection.works_including_child_works.include? works(:work1)
      expect(works(:work1).artists.length).to be > 0
      expect(works(:work1).time_spans.length).to be > 0

      attributes_of_interest = %w[ title tag_list sources object_categories techniques damage_types frame_damage_types themes purchase_price_currency style cluster_name medium condition_work condition_frame subset placeability work_status owner_name ]
      string_compare_attributes_of_interest = %w[ created_at significantly_updated_at updated_at  time_spans ]

      work_pairs = collections(:collection1).works_including_child_works.pluck(:id).collect{|id| [Work.find(id), Work.find("99#{id}")]}
      work_pairs.each do |pair|
        expect(pair[1].artists.map(&:last_name)).to eq(pair[0].artists.map(&:last_name))
        expect(pair[1].artists.map(&:first_name)).to eq(pair[0].artists.map(&:first_name))
        expect(pair[1].artists.map(&:description)).to eq(pair[0].artists.map(&:description))
        attributes_of_interest.each do |attribute|
          expect(pair[1].send(attribute)).to eq(pair[0].send(attribute))
        end
        string_compare_attributes_of_interest.each do |str_attribute|
          if pair[1].send(str_attribute).public_methods.include?(:[])
            expect(pair[1].send(str_attribute)[0].to_s).to eq(pair[0].send(str_attribute)[0].to_s)
          else
            expect(pair[1].send(str_attribute).to_s).to eq(pair[0].send(str_attribute).to_s)
          end
        end
      end
    end
  end
end