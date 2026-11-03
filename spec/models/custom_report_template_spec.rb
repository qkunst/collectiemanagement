# frozen_string_literal: true

# == Schema Information
#
# Table name: custom_report_templates
#
#  id            :integer          not null, primary key
#  title         :string
#  text          :text
#  collection_id :integer
#  work_fields   :text
#  hide          :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require "rails_helper"

RSpec.describe CustomReportTemplate, type: :model do
  describe "validations" do
    it "requires a title" do
      template = described_class.new

      expect(template).not_to be_valid
      expect(template.errors[:title]).to include("can't be blank")
    end
  end

  describe "aliases and visibility helpers" do
    it "aliases name and contents to the stored attributes" do
      template = described_class.new(title: "Overview", text: "Body")

      expect(template.name).to eq("Overview")
      expect(template.contents).to eq("Body")
    end

    it "supports the hidden helpers and scopes" do
      visible = custom_report_templates(:minimal_custom_report_template)
      hidden = described_class.create!(title: "Hidden template", hide: true)

      expect(hidden).to be_hidden
      expect(described_class.not_hidden).to include(visible)
      expect(described_class.not_hidden).not_to include(hidden)
      expect(described_class.show_hidden).to include(hidden)
      expect(described_class.show_hidden(false)).to include(visible)
      expect(described_class.show_hidden(false)).not_to include(hidden)
    end
  end
end
