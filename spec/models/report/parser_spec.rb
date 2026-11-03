# frozen_string_literal: true

require "rails_helper"

class ReportParserNode < ActiveSupport::HashWithIndifferentAccess
  def buckets
    self[:buckets]
  end

  def doc_count
    self[:doc_count]
  end
end

RSpec.describe Report::Parser, type: :model do
  before do
    described_class.key_model_relations = {}
  end

  describe ".parse" do
    it "parses nested buckets, preserves keyword keys, and merges missing buckets" do
      lookup = Class.new do
        def self.names(value)
          "Owner #{value.join("-")}"
        end
      end
      described_class.key_model_relations = {owner: lookup}

      result = described_class.parse(
        {
          owner: ReportParserNode.new(
            buckets: [
              ReportParserNode.new(
                key: "7",
                doc_count: 3,
                tag_list: ReportParserNode.new(
                  buckets: [
                    ReportParserNode.new(key: "featured", doc_count: 1)
                  ]
                )
              )
            ]
          ),
          owner_missing: ReportParserNode.new(doc_count: 2)
        }
      )

      expect(result).to eq(
        owner: {
          "Owner 7" => {
            count: 3,
            subs: {
              tag_list: {
                "featured" => {count: 1, subs: {}}
              }
            }
          },
          missing: {count: 2, subs: {}}
        }
      )
    end

    it "zeros counts for base reports" do
      result = described_class.parse(
        {
          status_missing: ReportParserNode.new(doc_count: 4)
        },
        base_report: true
      )

      expect(result).to eq(
        status: {
          missing: {count: 0, subs: {}}
        }
      )
    end
  end
end
