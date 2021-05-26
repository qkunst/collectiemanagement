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

        visit collection_works_path(collection, group: :no_grouping, min_index: 0, max_index: 3, sort: :artist_name)

        works = collection.works_including_child_works.order_by(:artist_name)
        work_id_batch_1 = works[0..1].map(&:id)
        work_id_batch_2 = works[2..3].map(&:id)
        work_id_batch_3 = works[4..5].map(&:id)

        visit collection_works_path(collection, group: :no_grouping, min_index: 0, max_index: 1, sort: :artist_name)
        expect(page.body.to_s).to match(work_id_batch_1[0].to_s)
        expect(page.body.to_s).to match(work_id_batch_1[1].to_s)
        expect(page.body.to_s).not_to match(work_id_batch_2[0].to_s)
        expect(page.body.to_s).not_to match(work_id_batch_2[1].to_s)
        click_on("→")
        expect(page.body.to_s).not_to match(work_id_batch_1[0].to_s)
        expect(page.body.to_s).not_to match(work_id_batch_1[1].to_s)
        expect(page.body.to_s).to match(work_id_batch_2[0].to_s)
        expect(page.body.to_s).to match(work_id_batch_2[1].to_s)
        click_on("→")
        expect(page.body.to_s).not_to match(work_id_batch_2[0].to_s)
        expect(page.body.to_s).not_to match(work_id_batch_2[1].to_s)
        expect(page.body.to_s).to match(work_id_batch_3[0].to_s)
        # p page.body
      end
    end
  end
end
