# frozen_string_literal: true

require "rails_helper"

RSpec.describe Works::ModifiedForm, type: :model do
  describe "date coercion" do
    it "casts string values to dates and treats blank strings as nil" do
      form = described_class.new

      form.from_date = "2024-03-01"
      form.to_date = ""

      expect(form.from_date).to eq(Date.new(2024, 3, 1))
      expect(form.to_date).to be_nil
    end

    it "accepts Date values directly" do
      form = described_class.new
      date = Date.new(2024, 3, 2)

      form.to_date = date

      expect(form.to_date).to eq(date)
    end

    it "rejects unsupported values" do
      form = described_class.new

      expect { form.from_date = 123 }.to raise_error("Invalid from_date value")
      expect { form.to_date = 123 }.to raise_error("Invalid to_date value")
    end
  end

  describe "boolean flags" do
    it "treats 1, true and true-like strings as truthy" do
      form = described_class.new(only_location_changes: "1", only_non_qkunst: "true")

      expect(form).to be_only_location_changes
      expect(form).to be_only_non_qkunst
    end

    it "treats other values as falsey" do
      form = described_class.new(only_location_changes: "0", only_non_qkunst: nil)

      expect(form).not_to be_only_location_changes
      expect(form).not_to be_only_non_qkunst
    end
  end

  describe "#active?" do
    it "is false when no filters are set" do
      expect(described_class.new).not_to be_active
    end

    it "is true when any filter is set" do
      expect(described_class.new(from_date: "2024-03-01")).to be_active
      expect(described_class.new(only_location_changes: true)).to be_active
    end
  end
end
