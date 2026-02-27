# frozen_string_literal: true

require_relative "feature_helper"

RSpec.feature "Pagination of works", type: :feature do
  include FeatureHelper
  extend FeatureHelper

  let(:collection) { collections(:collection1) }

  ["qkunst-test-read_only@murb.nl", "qkunst-test-compliance@murb.nl"].each do |email_address|
    context email_to_role(email_address) do
      it "can paginate" do
        login email_address

        visit collection_works_path(collection, group: :no_grouping, min_index: 0, max_index: 6, sort: :artist_name)
        work_ids_on_page(page)
        works = collection.works_including_child_works.order_by(:artist_name).pluck(:id)
        expect(work_ids_on_page(page)).to eq(works)

        work_id_batch_1 = works[0..1]
        work_id_batch_2 = works[2..3]
        work_id_batch_3 = works[4..5]

        visit collection_works_path(collection, group: :no_grouping, min_index: 0, max_index: 1, sort: :artist_name)
        expect(work_ids_on_page(page)).to eq(work_id_batch_1)
        click_on("→")
        expect(work_ids_on_page(page)).to eq(work_id_batch_2)
        click_on("→")
        expect(work_ids_on_page(page)).to eq(work_id_batch_3)
      end
    end
  end

  def work_ids_on_page(page)
    page.body.scan(/\/collections\/\d*\/works\/(\d*)/).flatten.uniq.map(&:to_i)
  end
end
