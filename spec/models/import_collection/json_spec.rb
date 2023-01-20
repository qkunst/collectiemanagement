# frozen_string_literal: true

require "rails_helper"

RSpec.describe ImportCollection, type: :model do
  describe "instance methods" do
    describe "#write_json_work" do
      it "creates a simple work" do
        title = "New work very unique json imported"
        import_collections(:import_collection1).write_json_work({"title" => title})
        expect(collections(:collection1).works.where(title: title).count).to eq(1)
      end
      it "creates a new artist if id is given" do
        title = "New work very unique json imported with artist"
        import_collections(:import_collection1).write_json_work({"title" => title, "artists" => [{"rkd_artist_id" => 123, "last_name" => "Camembert"}]})

        work = collections(:collection1).works.find_by(title: title)
        expect(work.title).to eq(title)
        expect(work.artists.map(&:last_name)).to include "Camembert"
      end

      it "adds techniques" do
        data = '{
          "stock_number": "T15001",
          "title": "Imperial",
          "title_rendered": "Imperial",
          "location": "Denneweg",
          "location_floor": null,
          "location_detail": "BG",
          "medium_comments": " archival pigment print",
          "category": {
            "name": "Fotografie"
          },
          "techniques": [
            {
              "name": "Foto"
            },
            {
              "name": "Archiefinkt"
            }
          ],
          "print": "6/25",
          "artists": [
            {
              "first_name": "Dana",
              "prefix": "",
              "last_name": "Iets",
              "place_of_birth": "Amsterdam, 1964",
              "year_of_death": null
            },
            {
              "first_name": "Voornaam",
              "prefix": "",
              "last_name": "Nieuwe oorspronkelijke achter",
              "date_of_birth": null,
              "place_of_birth": "",
              "year_of_death": null
            }
          ],
          "frame_height": 33.0,
          "frame_width": 41.0,
          "purchase_price": 3500.0,
          "purchased_on": "2019-09-23",
          "object_creation_year": 2008,
          "internal_comments": "",
          "public_description": null,
          "for_purchase_at": null,
          "for_rent_at": "2022-06-29",
          "selling_price": 5000.0,
          "time_spans": [
            {
              "contact": {
                "external": true,
                "url": "http://localhost:5001/customers/86679f73-bbc4-46aa-bc38-61d9fb2b2ac0",
                "name": ""
              },
              "starts_at": "2020-11-26",
              "ends_at": "2021-11-26",
              "status": "finished",
              "classification": "rental_outgoing"
            }
          ],
          "highlight": false}
        '

        import_collections(:import_collection1).write_json_work(JSON.parse(data))

        work = collections(:collection1).works.find_by(stock_number: "T15001")
        expect(work.techniques.map(&:name)).to include "Foto"
        expect(work.time_spans.count).to eq(1)
        expect(work.artists.count).to eq(2)
        expect(work.artists.first.last_name).to eq("Iets")
      end

      it "works also for this" do
        data = '{"stock_number":"AA1234","artist_name_rendered_without_years_nor_locality":"Ander Iemand","title":"Naam","title_rendered":"Naam","location":"Boterweg","location_floor":null,"location_detail":"","medium":{"name":"Steen"},"medium_comments":"Steen Divers","object_categories":[{"name":"Sculptuur"}],"techniques":[{"name":"(Wand)objekt"},{"name":"Gemengde techniek"}],"artists":[{"first_name":"Ander","prefix":"","last_name":"Iemand","date_of_birth":null,"place_of_birth":"","year_of_death":null}],"purchase_price":2000,"purchased_on":"2020-12-29","object_creation_year":2020,"internal_comments":"Aangekocht door ","public_description":null,"for_purchase_at":null,"for_rent_at":null,"selling_price":225.0,"time_spans":[{"starts_at":"2020-12-29","status":"active","classification":"purchase","uuid":"990d1ac1-d333-43d6-aec9-99d44396c54e","contact":{"external":true,"url":"http://localhost:5001/customers/039cc031-5284-4c5f4789d"}}]}'
        import_collections(:import_collection1).write_json_work(JSON.parse(data))

        work = collections(:collection1).works.find_by(stock_number: "AA1234")
        expect(work.time_spans.count).to eq 1
        expect(work.object_categories.first.name).to eq "Sculptuur"
      end
    end
  end
end
