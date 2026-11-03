# frozen_string_literal: true

require "rails_helper"

class ReportBuilderHelpersTestClass
  extend Report::BuilderHelpers
end

RSpec.describe Report::BuilderHelpers, type: :model do
  describe ".basic_aggregation_snippet" do
    it "builds a terms aggregation with an optional missing bucket and nested aggs" do
      result = ReportBuilderHelpersTestClass.basic_aggregation_snippet(
        :owner,
        postfix: ".id",
        include_missing: true,
        aggregation: {
          works: {
            terms: {field: "works.id", size: 999}
          }
        }
      )

      expect(result).to eq(
        owner: {
          terms: {field: "owner.id", size: 999},
          aggs: {
            works: {
              terms: {field: "works.id", size: 999}
            }
          }
        },
        owner_missing: {
          missing: {field: "owner.id"}
        }
      )
    end

    it "prefers a block over a provided aggregation hash" do
      result = ReportBuilderHelpersTestClass.basic_aggregation_snippet(:owner, aggregation: {ignored: true}) do
        {works: {terms: {field: "works.id", size: 5}}}
      end

      expect(result).to eq(
        owner: {
          terms: {field: "owner", size: 999},
          aggs: {
            works: {
              terms: {field: "works.id", size: 5}
            }
          }
        }
      )
    end
  end

  describe ".missing_only_aggregation_snippet" do
    it "builds a missing aggregation with nested aggs" do
      result = ReportBuilderHelpersTestClass.missing_only_aggregation_snippet(
        :owner,
        field: "owner.id",
        aggregation: {
          ignored: true
        }
      ) do
        {works: {terms: {field: "works.id", size: 5}}}
      end

      expect(result).to eq(
        owner: {
          missing: {field: "owner.id"},
          aggs: {
            works: {
              terms: {field: "works.id", size: 5}
            }
          }
        }
      )
    end
  end
end
