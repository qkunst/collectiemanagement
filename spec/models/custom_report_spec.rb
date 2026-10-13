# frozen_string_literal: true

require "rails_helper"

RSpec.describe CustomReport, type: :model do
  let(:collection) { collections(:collection1) }
  let(:template) do
    CustomReportTemplate.new(
      title: "Collection overview",
      text: "Hello {{name}}"
    )
  end

  describe "#template_fields" do
    it "delegates to the template fields" do
      report = described_class.new(custom_report_template: template)

      expect(report.template_fields).to eq(["name"])
    end
  end

  describe "#title" do
    it "returns the explicit title when present" do
      report = described_class.new(title: "Manual title", custom_report_template: template)

      expect(report.title).to eq("Manual title")
      expect(report.name).to eq("Manual title")
    end

    it "builds a fallback title from the template name and creation date" do
      report = described_class.new(
        custom_report_template: template,
        created_at: Time.zone.local(2024, 3, 5)
      )
      allow(I18n).to receive(:l).with(Date.new(2024, 3, 5), format: :long).and_return("5 March 2024")

      expect(report.title).to eq("Collection overview, 5 March 2024")
    end
  end

  describe "#title_with_collection" do
    it "prefixes the report title with the collection name" do
      report = described_class.new(
        title: "Inventory",
        collection:,
        custom_report_template: template
      )

      expect(report.title_with_collection).to eq("Collection 1: Inventory")
    end
  end

  describe "#merged_content" do
    it "merges template variables into the template content" do
      report = described_class.new(
        custom_report_template: template,
        variables: {name: "Ada"}
      )

      expect(report.merged_content).to eq("Hello Ada")
    end
  end
end
