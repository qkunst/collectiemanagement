# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Works", type: :request do
  describe "PATCH /collections/:collection_id/works/:id" do
    let(:user) { users(:admin) }

    it "should render the edit form when changing location fails" do
      work = works(:work6)
      work.collection = collections(:collection1)
      work.save
      work.update_column(:cluster_id, clusters(:cluster_private_to_collection_with_stages).id)

      new_location = "New Location By Admin"

      sign_in user
      patch collection_work_path(works(:work6).collection, works(:work6)), params: {work: {location: new_location}}

      expect(response).to have_http_status(200)
      expect(response.body).to match("work_frame_height") # edit form

      work.reload
      expect(work.location).to eq(nil)
    end
  end
  describe "GET /collections/:id/works" do
    it "shouldn't be publicly accessible!" do
      collection = collections(:collection1)
      get collection_works_path(collection)
      expect(response).to have_http_status(302)
    end
    context "admin" do
      let(:user) { users(:admin) }
      it "should be accessible when logged in as admin" do
        sign_in user
        get edit_collection_work_path(works(:work1).collection, works(:work1))
        expect(response).to have_http_status(200)
      end
      it "admin should be able to access edit page" do
        sign_in user
        collection = collections(:collection1)
        get collection_works_path(collection)
        expect(response).to have_http_status(200)
      end
      it "should be able to get an index" do
        collection = collections(:collection1)
        sign_in user
        get collection_works_path(collection)
        expect(response).to have_http_status(200)
        expect(response.body).not_to match("<h3>wind</h3>")
      end
      describe "sorting and grouping" do
        it "should be able to get a grouped index" do
          collection = collections(:collection1)
          sign_in user
          get collection_works_path(collection, params: {group: :themes})
          expect(response).to have_http_status(200)
          expect(response.body).to match("<h3>wind</h3>")
        end
        it "should be able to sort" do
          collection = collections(:collection1)
          sign_in user

          get collection_works_path(collection)
          response_body = response.body
          expect(response_body.index("<h4>Work1") < response_body.index("<h4>Work2")).to eq(true)
          expect(response_body.index("<h4>Work2") < response_body.index("<h4>Work5")).to eq(true)

          get collection_works_path(collection, params: {sort: :location})
          response_body = response.body
          expect(response_body.index("<h4>Work1") < response_body.index("<h4>Work5")).to eq(true)
          expect(response_body.index("<h4>Work5") < response_body.index("<h4>Work2")).to eq(true)
        end
        it "should be able to filter and sort" do
          collection = collections(:collection1)

          # required for TravisCI
          collections(:collection1).works_including_child_works.all.reindex!

          sign_in user

          get collection_works_path(collection, params: {filter: {location_raw: ["Adres"]}})
          response_body = response.body

          expect(response_body.index("<h4>Work1") < response_body.index("<h4>Work2")).to eq(true)
          expect(response_body.index("<h4>Work2") < response_body.index("<h4>Work5")).to eq(true)

          get collection_works_path(collection, params: {sort: :location, filter: {location_raw: ["Adres"]}})
          response_body = response.body
          expect(response_body.index("<h4>Work1") < response_body.index("<h4>Work5")).to eq(true)
          expect(response_body.index("<h4>Work5") < response_body.index("<h4>Work2")).to eq(true)
        end
      end
      describe "downloading" do
        describe "zip" do
          it "should be able to get an zip file" do
            collection = collections(:collection1)
            sign_in user
            get collection_works_path(collection, format: :zip)
            expect(response).to have_http_status(200)
            expect(response.content_type).to eq("application/zip")
            expect(response.body).to match(/Zip/)
          end
          it "should be able to get an zip file with photos" do
            collection = collections(:collection1)
            work = collection.works_including_child_works.first
            FileUtils.cp(File.expand_path("../fixtures/image.jpg", __dir__), File.expand_path("../fixtures/image2.jpg", __dir__))
            FileUtils.cp(File.expand_path("../fixtures/image.jpg", __dir__), File.expand_path("../fixtures/image3.jpg", __dir__))
            work.photo_front = File.open(File.expand_path("../fixtures/image2.jpg", __dir__))
            work.photo_back = File.open(File.expand_path("../fixtures/image3.jpg", __dir__))
            work.save
            sign_in user
            get collection_works_path(collection, format: :zip)
            expect(response).to have_http_status(200)
            expect(response.content_type).to eq("application/zip")
            expect(response.body).to match(/Zip/)
            expect(response.body).to match("#{work.stock_number}_front.jpg")
            expect(response.body).to match("#{work.stock_number}_back.jpg")
          end
          it "should be able to get an zip file with only front photos" do
            collection = collections(:collection1)
            work = collection.works_including_child_works.first
            FileUtils.cp(File.expand_path("../fixtures/image.jpg", __dir__), File.expand_path("../fixtures/image2.jpg", __dir__))
            FileUtils.cp(File.expand_path("../fixtures/image.jpg", __dir__), File.expand_path("../fixtures/image3.jpg", __dir__))
            work.photo_front = File.open(File.expand_path("../fixtures/image2.jpg", __dir__))
            work.photo_back = File.open(File.expand_path("../fixtures/image3.jpg", __dir__))
            work.save
            sign_in user
            get collection_works_path(collection, format: :zip, params: {only_front: true})
            expect(response).to have_http_status(200)
            expect(response.content_type).to eq("application/zip")
            expect(response.body).to match(/Zip/)
            expect(response.body).to match("#{work.stock_number}.jpg")
            expect(response.body).not_to match("#{work.stock_number}_front.jpg")
            expect(response.body).not_to match("#{work.stock_number}_back.jpg")
          end
        end
        describe "xml" do
          let(:get_index) { get collection_works_path(collections(:collection1), format: :xml) }

          it "requires login" do
            get_index
            expect(response).to have_http_status(401)
          end
          it "rejects facility" do
            sign_in users(:facility_manager)

            get_index

            expect(response).to have_http_status(302)
          end
          it "downloads for admin" do
            sign_in user

            get_index

            expect(response).to have_http_status(200)
            expect(response.body).to start_with("<?xml version=\"1.0\"?>")
            expect(response.body).to match("<dc:identifier xsi:scheme=\"stock_number_file_safe\">Q001</dc:identifier>")
          end
        end
      end
    end
    describe "filtering & searching" do
      let(:user) { users(:admin) }
      let(:collection) { collections(:collection1) }

      before do
        sign_in user
      end

      describe "tag filtering" do
        it "should return no works when tags do not exist" do
          get collection_works_path(collection, params: { filter: { tags: ["nonexistingtag"] } })
          expect(response.body).to match(/Deze\s*\(gefilterde\)\s*collectie bevat\s*geen werken\s*\(van de 3 werken\)/)
        end
        it "should use AND for tags" do
          w1, w2, w3 = collection.works_including_child_works[0..2]
          w1.tag_list = ["tagtest1"]
          w1.save

          w2.tag_list = ["tagtest1", "tagtest2"]
          w2.save

          w3.tag_list = ["tagtest3", "tagtest2"]
          w3.save

          collection.works_including_child_works.reindex!

          get collection_works_path(collection, params: { filter: { tag_list: ["tagtest1"] } })
          expect(response.body).to match(/Deze\s*\(gefilterde\)\s*collectie bevat\s*2 werken\s*\(van de 3 werken\)/)

          get collection_works_path(collection, params: { filter: { tag_list: ["tagtest1", "tagtest2"] } })
          expect(response.body).to match(/Deze\s*\(gefilterde\)\s*collectie bevat\s*1 werk\s*\(van de 3 werken\)/)
        end
      end
    end
    context "user with no rights" do
      let(:user) { users(:user_with_no_rights) }

      it "should not be accessible when logged in as an anonymous user" do
        sign_in user
        collection = collections(:collection1)
        get collection_works_path(collection)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to root_path
      end
    end
    context "facility" do
      let(:user) { users(:facility_manager) }

      it "should not be able to see a work from another collection" do
        sign_in user

        expect {
          get collection_work_path(works(:work6).collection, works(:work6))
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "should be able to see the work when work is in an accessible collection" do
        work = works(:work6)
        work.collection = collections(:collection1)
        work.save

        sign_in user
        get collection_work_path(works(:work6).collection, works(:work6))
        expect(response).to have_http_status(200)
      end

      it "should not be able to edit the work" do
        work = works(:work6)
        work.collection = collections(:collection1)
        work.save

        sign_in user
        get edit_collection_work_path(works(:work6).collection, works(:work6))
        expect(response).to have_http_status(302)
      end

      it "should be able to edit the location" do
        work = works(:work6)
        work.collection = collections(:collection1)
        work.save

        sign_in user
        get collection_work_edit_location_path(works(:work6).collection, works(:work6))
        expect(response).to have_http_status(200)
      end

      it "should be able to update the location" do
        work = works(:work6)
        work.collection = collections(:collection1)
        work.save

        new_location = "New Location By Facility"

        sign_in user
        patch collection_work_path(works(:work6).collection, works(:work6)), params: {work: {location: new_location}}

        expect(response).to redirect_to(collection_work_path(works(:work6).collection, works(:work6)))

        work.reload
        expect(work.location).to eq(new_location)
      end

      it "should not render the edit form" do
        work = works(:work6)
        work.collection = collections(:collection1)
        work.save
        work.update_column(:cluster_id, clusters(:cluster_private_to_collection_with_stages).id)

        new_location = "New Location By Facility"

        sign_in user
        patch collection_work_path(works(:work6).collection, works(:work6)), params: {work: {location: new_location}}

        expect(response).to redirect_to(collection_work_path(works(:work6).collection, works(:work6)))
        work.reload
        expect(work.location).to eq(nil)
      end
    end
    context "read only user" do
      let(:user) { users(:read_only_user) }

      it "should allow accesss to the single collection the user has access to" do
        sign_in user
        collection = collections(:collection1)
        get collection_works_path(collection)
        expect(response).to have_http_status(200)
      end
      it "should not allow accesss to a work in another collection by accessing it through another collection the user has access to" do
        sign_in user
        expect {
          get collection_work_path(collections(:collection1), works(:work6))
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
      it "should not allow accesss to a work in collection the user has no access to" do
        sign_in user
        expect {
          get collection_work_path(works(:work6).collection, works(:work6))
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
      it "should redirect to the root when accessing anohter collection" do
        sign_in user
        collection = collections(:collection3)
        get collection_works_path(collection)
        expect(response).to have_http_status(302)
        expect(response).to redirect_to root_path
      end
    end
  end
end
