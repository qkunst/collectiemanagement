# frozen_string_literal: true

# == Schema Information
#
# Table name: collection_attributes
#
#  id               :bigint           not null, primary key
#  attribute_type   :string           default("unknown")
#  attributed_type  :string
#  label            :string
#  language         :string
#  value_ciphertext :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  attributed_id    :bigint
#  collection_id    :bigint
#
require "rails_helper"

RSpec.describe CollectionAttribute, type: :model do
  let(:artist) { artists(:artist1) }
  let(:value) { "very secret" }

  context "class methods" do
    context ".create" do
      it "creates with an encrypted value" do
        artist = artists(:artist1)
        value = "very secret"
        ca = CollectionAttribute.create(value: value, collection: collections(:collection1), attributed: artist, label: "Kaas")
        expect(ca.value_ciphertext).not_to eq(value)
        expect(ca.value).to eq(value)
        expect(CollectionAttribute.column_names).to include("label")
        expect(CollectionAttribute.column_names).not_to include("value")
      end

      it "defaults to base_collection" do
        ca = CollectionAttribute.create(value: value, collection: collections(:collection_with_stages_child), attributed: artist, label: "Kaas")
        expect(ca.collection).to eq(collections(:collection_with_stages))
      end
    end
  end

  context "scopes" do
    context ".for_user (currently not used)" do
      it "does not return parent collection's data if the user does not have access to that collection" do
        attributes = CollectionAttribute.for_user(users(:collection_with_works_child_user)).all

        expect(attributes).to include(collection_attributes(:artist_1_collection_with_works_child_attribute))
        expect(attributes).not_to include(collection_attributes(:artist_1_collection1_attribute))
      end
      it "does return parent collection's data if the user has access to that collection" do
        attributes = CollectionAttribute.for_user(users(:read_only)).all # read only has access tot collection1

        expect(attributes).to include(collection_attributes(:artist_1_collection_with_works_child_attribute))
        expect(attributes).to include(collection_attributes(:artist_1_collection1_attribute))
      end
    end
    context ".for_collection" do
      it "returns one for the stages collection" do
        attributes = CollectionAttribute.for_collection(collections(:collection_with_stages)).all

        expect(attributes.map(&:collection)).to include(collections(:collection_with_stages))
        expect(attributes.map(&:collection)).to include(collections(:collection_with_stages_child))

        attributes = CollectionAttribute.for_collection(collections(:collection_with_stages_child)).all

        expect(attributes.map(&:collection)).not_to include(collections(:collection_with_stages))
        expect(attributes.map(&:collection)).to include(collections(:collection_with_stages_child))
      end
    end

    describe "default scope" do
      it "always renders nl before en" do
        results = CollectionAttribute.all.pluck(:language)
        expect(results).to include("en")

        expect(results[0]).to eq("nl")
      end
    end
  end

  describe "validations" do
    it "only accepts dutch and english" do
      good = {value: "value", collection: collections(:collection1), attributed: artists(:artist1), label: "Kaas"}
      expect(CollectionAttribute.new(**good.merge({language: "nl"}))).to be_valid
      expect(CollectionAttribute.new(**good.merge({language: "en"}))).to be_valid
      expect(CollectionAttribute.new(**good.merge({language: "not_applicable"}))).to be_valid
      expect(CollectionAttribute.new(**good.merge({language: "de"}))).not_to be_valid
    end
    it "only accepts dutch and english" do
      good = {value: "value", collection: collections(:collection1), attributed: artists(:artist1), label: "Kaas"}
      expect(CollectionAttribute.new(**good.merge({language: "nl"}))).to be_valid
      expect(CollectionAttribute.new(**good.merge({language: "en"}))).to be_valid
      expect(CollectionAttribute.new(**good.merge({language: "de"}))).not_to be_valid
    end
  end

  describe "callbacks" do
    it "set significantly updated at on update for works when artist is updated" do
      ca = collection_attributes(:artist_1_collection1_attribute)
      expect(ca.attributed.works.first.significantly_updated_at).not_to be_within(1.second).of(Time.zone.now)

      ca.update(value: "new value")
      expect(ca.attributed.works.first.significantly_updated_at).to be_within(1.second).of(Time.zone.now)
    end

    it "set significantly updated at on update for works when work attribute is updated" do
      ca = collection_attributes(:work1_collection_attributes_description_en)
      expect(ca.attributed.significantly_updated_at).not_to be_within(1.second).of(Time.zone.now)
      ca.update(value: "new value")
      expect(ca.attributed.significantly_updated_at).to be_within(1.second).of(Time.zone.now)
    end
  end
end
