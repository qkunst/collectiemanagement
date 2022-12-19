# frozen_string_literal: true

require "rails_helper"

RSpec.describe "WorkBatchs", type: :request do
  describe "GET /collections/:id/batch/" do
    describe "Collection defense" do
      it "shouldn't be publicly accessible!" do
        collection = collections(:collection1)
        get collection_batch_path(collection)
        expect(response).to have_http_status(302)
      end
      it "should be accessible when logged in as admin" do
        user = users(:admin)
        collection = collections(:collection1)
        sign_in user
        get collection_batch_path(collection)
        expect(response).to have_http_status(200)
      end
      it "should not be accessible when logged in as an anonymous user" do
        sign_in users(:user_with_no_rights)
        get collection_batch_path(collections(:collection1))
        expect(response).to have_http_status(302)
        expect(response).to redirect_to root_path
      end
      it "should not be accessible when logged in as an registrator user" do
        sign_in users(:qkunst)
        get collection_batch_path(collections(:collection1))
        expect(response).to have_http_status(302)
        expect(response).to redirect_to root_path
      end
      it "should not allow accesss to the batch editor for non qkunst user has access to" do
        user = users(:read_only)
        sign_in user
        collection = collections(:collection3)
        get collection_batch_path(collection)
        expect(response).to have_http_status(302)
      end

      it "should redirect to the root when accessing anohter collection" do
        user = users(:read_only)
        sign_in user
        collection = collections(:collection1)
        get collection_batch_path(collection)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to root_path
      end
    end
    describe "Selection of works" do
      let(:user) { users(:admin) }
      let(:collection) { collections(:collection1) }
      let(:works) { [] }

      let(:expectations_checker) do
        works.each do |work|
          expect(response.body).to match(work.title)
          expect(response.body).to match(work.stock_number)
        end
      end

      before do
        sign_in user
        works.reindex!
      end

      after do
        expectations_checker
      end

      describe "by ids" do
        let(:works) { collection.works_including_child_works.limit(2) }

        it "should work for get with selected_works array" do
          get collection_batch_path(collection, params: {selected_works: works.map(&:id)})
        end

        it "should work for post with selected_works array" do
          post collection_batch_path(collection, params: {selected_works: works.map(&:id)})
        end
      end

      describe "with filter" do
        let(:theme) { themes(:wind) }
        let(:works) { collection.works_including_child_works.joins(:themes).where(themes: theme) }

        it "off" do
          expect(works.count).to be == 2
          post collection_batch_path(collection, params: {selected_work_groups: {themes: [theme.id]}})
        end

        describe "on" do
          let(:works) { collection.works_including_child_works.joins(:themes).where(themes: theme).where(market_value: 50) }

          it "works", requires_elasticsearch: true do
            expect(works.count).to be == 1

            post collection_batch_path(collection, params: {selected_work_groups: {themes: [theme.id]}, filter: {market_value: [50]}})

            other_works_stock_number = (collection.works_including_child_works.joins(:themes).where(themes: theme).map(&:stock_number) - works.pluck(:stock_number))

            expect(response.body).not_to match(other_works_stock_number[0])
          end
        end
      end

      describe "with search", requires_elasticsearch: true do
        let(:q) { "\"Bijzondere tekst\"" }
        let(:works) { collection.works_including_child_works }

        it "off" do
          expect(works.count).to be == 5
          post collection_batch_path(collection, params: {selected_work_groups: {all: [:all]}})
        end

        describe "on" do
          let(:works) { collection.works_including_child_works.where(description: "Bijzondere tekst") }

          it "works" do
            works.reindex!
            expect(works.count).to be == 1
            post collection_batch_path(collection, params: {selected_work_groups: {all: [:all]}, q: q})

            other_works_stock_number = (collection.works_including_child_works.map(&:stock_number) - works.pluck(:stock_number))

            expect(response.body).not_to match(other_works_stock_number[0])
          end
        end
      end

      describe "by cluster group" do
        let(:cluster) { clusters(:cluster1) }
        let(:works) { collection.works_including_child_works.where(cluster: clusters(:cluster1)) }

        it "should work for post with cluster ids" do
          expect(works.count).to be >= 1
          post collection_batch_path(collection, params: {selected_work_groups: {cluster: [cluster.id]}})
        end
      end
    end
    describe "Field-accessibility" do
      it "describe facility should only be able to edit location" do
        sign_in users(:facility_manager)
        get collection_batch_path(collections(:collection1))
        response_body = response.body
        expect(response_body).to match('Adres en\/of gebouw\(deel\)\<\/label\>')
        expect(response_body).not_to match('Overige opmerkingen<\/label>')
        expect(response_body).not_to match('Aankoopprijs<\/label>')
        expect(response_body).not_to match('Marktwaardecategorie \(€\)<\/label>')
        expect(response_body).not_to match('Overige opmerkingen<\/label>')
      end
      it "describe facility should only be able to edit location" do
        sign_in users(:appraiser)
        get collection_batch_path(collections(:collection1))
        response_body = response.body
        expect(response_body).to match("Waardering door")
        expect(response_body).to match('Adres en\/of gebouw\(deel\)\<\/label\>')
        expect(response_body).to match('Overige opmerkingen<\/label>')
        expect(response_body).to match('Aankoopprijs<\/label>')
        expect(response_body).to match('Marktwaardecategorie \(€\)<\/label>')
        expect(response_body).to match('Overige opmerkingen<\/label>')
      end
    end
  end
  describe "PATCH /collection/:collection_id/batch" do
    let(:work_selection) { [works(:work1)] }

    describe "appraisal" do
      it "should store appraisal" do
        sign_in users(:appraiser)
        appraisal_date = "2012-07-21".to_date
        patch collection_batch_path(collections(:collection1)), params: {work_ids_comma_separated: work_selection.map(&:id).join(","), work: {appraisals_attributes: {"0": {appraised_on: appraisal_date, update_appraised_on_strategy: "REPLACE", market_value: 2_000, update_market_value_strategy: "REPLACE", reference: "abc", update_reference_strategy: "REPLACE"}}}}
        appraisal = Appraisal.find_by(appraised_on: appraisal_date)
        expect(appraisal.appraised_on).to eq(appraisal_date)
        expect(appraisal.market_value).to eq(2_000)
        expect(appraisal.reference).to eq("abc")
        expect(response).to redirect_to collection_works_path(ids: work_selection.map(&:id).join(","))
      end
      it "should ignore ignored fields" do
        sign_in users(:appraiser)
        appraisal_date = Time.now.to_date
        patch collection_batch_path(collections(:collection1)), params: {work_ids_comma_separated: work_selection.map(&:id).join(","), work: {appraisals_attributes: {"0": {appraised_on: appraisal_date, update_appraised_on_strategy: "REPLACE", appraised_by: "Harald", update_appraised_by_strategy: "REPLACE", market_value: 2_000, update_market_value_strategy: "REPLACE", reference: "abc", update_reference_strategy: "IGNORE"}}}}
        appraisal = Appraisal.find_by(appraised_on: appraisal_date)
        expect(appraisal.appraised_on).to eq(appraisal_date)
        expect(appraisal.market_value).to eq(2_000)
        expect(appraisal.appraised_by).to eq("Harald")
        expect(appraisal.reference).to eq(nil)
        expect(response).to redirect_to collection_works_path(ids: work_selection.map(&:id).join(","))
      end
      context "diptych" do
        let(:work_selection) { [works(:work1), works(:work_diptych_1)] }

        it "should stop when work cannot be appraised (diptych scenario)" do
          sign_in users(:appraiser)
          appraisal_date = Time.now.to_date + 5.day
          patch collection_batch_path(collections(:collection3)), params: {work_ids_comma_separated: work_selection.map(&:id).join(","), work: {appraisals_attributes: {"0": {appraised_on: appraisal_date, update_appraised_on_strategy: "REPLACE", appraised_by: "Harald", update_appraised_by_strategy: "REPLACE", market_value: 2_000, update_market_value_strategy: "REPLACE", reference: "abc", update_reference_strategy: "IGNORE"}}}}
          appraisal = Appraisal.find_by(appraised_on: appraisal_date)
          expect(appraisal).to eq(nil)
          expect(response.body).to match("Het gewaardeerde werk is niet afzonderlijk te waarderen")
        end
      end
    end

    describe "themes" do
      let(:work_selection) { [works(:work1), works(:work2)] }

      it "appends themes" do
        sign_in users(:admin)
        collection = collections(:collection1)
        theme = themes(:fire)

        patch collection_batch_path(collection), params: {work_ids_comma_separated: work_selection.map(&:id).join(","), work: {collection_id: collection.id, theme_ids: ["", theme.id], update_theme_ids_strategy: "APPEND"}}
        expect(response).to have_http_status(302)
        expect(response).to redirect_to collection_works_path(ids: work_selection.map(&:id).sort.join(","))

        work_selection.each do |work|
          work = Work.find(work.id)
          expect(work.themes).to include(theme)
        end
      end

      it "allows for group selections" do
        sign_in users(:admin)
        collection = collections(:collection1)
        theme = themes(:wind)

        post collection_batch_path(collection), params: {"selected_work_groups" => {"themes" => [theme.id]}, "collection_id" => collection.id}

        expect(response.body).to match("Q001")
        expect(response.body).to match("Q002")
        expect(response.body).not_to match("Q005")
        expect(response.body).not_to match("Q007")

        expect(response.body).to match("2 werken bijwerken")

        post collection_batch_path(collection), params: {"selected_work_groups" => {"themes" => [theme.id, "not_set"]}, "collection_id" => collection.id}

        expect(response.body).to match("Q001")
        expect(response.body).to match("Q002")
        expect(response.body).to match("Q005")
        expect(response.body).to match("Q007")
        expect(response.body).to match(/\d werken bijwerken/)
      end
    end
    describe "tag_list" do
      it "should REPLACE" do
        sign_in users(:admin)
        collection = collections(:collection1)
        works = [works(:work1), works(:work2)]
        works.collect do |a|
          a.tag_list = ["existing_tag"]
          a.save
        end
        patch collection_batch_path(collection), params: {work_ids_comma_separated: works.map(&:id).join(","), work: {collection_id: collection.id, tag_list: ["eerste nieuwe tag", "first new tag"], update_tag_list_strategy: "REPLACE"}}
        expect(response).to have_http_status(302)
        works.collect do |a|
          a.reload
        end
        expect(works.first.tag_list).to match_array(["eerste nieuwe tag", "first new tag"])
      end
      it "should APPEND" do
        sign_in users(:admin)
        collection = collections(:collection1)
        works = [works(:work1), works(:work2)]
        works.collect do |a|
          a.tag_list = ["existing_tag"]
          a.save
        end
        patch collection_batch_path(collection), params: {work_ids_comma_separated: works.map(&:id).join(","), work: {collection_id: collection.id, tag_list: ["eerste nieuwe tag", "first new tag"], update_tag_list_strategy: "APPEND"}}
        expect(response).to have_http_status(302)
        works.collect { |a| a.reload }
        expect(works.first.tag_list).to match_array(["existing_tag", "eerste nieuwe tag", "first new tag"])
      end
      it "should REMOVE" do
        sign_in users(:admin)
        collection = collections(:collection1)
        works = [works(:work1), works(:work2)]
        works.collect do |a|
          a.tag_list = ["existing_tag", "tag to delete"]
          a.save
        end
        patch collection_batch_path(collection), params: {work_ids_comma_separated: works.map(&:id).join(","), work: {collection_id: collection.id, tag_list: ["tag to delete", "eerste nieuwe tag", "first new tag"], update_tag_list_strategy: "REMOVE"}}
        expect(response).to have_http_status(302)
        works.collect { |a| a.reload }
        expect(works.first.tag_list).to match_array(["existing_tag"])
      end
    end
  end
end
