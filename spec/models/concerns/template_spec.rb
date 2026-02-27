# frozen_string_literal: true

require "rails_helper"

class TemplateTestImpl
  include ActiveModel::Validations
  include Template

  attr_accessor :contents
end

RSpec.describe Template, type: :model do
  describe "#contents_as_html" do
    it "should return an empty string when nil" do
      expect(TemplateTestImpl.new.contents_as_html).to eq("")
    end
    it "should parse simple markdown" do
      template = TemplateTestImpl.new
      template.contents = "# heading 1\n\nparagraph\n"
      expect(template.contents_as_html).to eq("<h1 id=\"heading-1\">heading 1</h1>\n\n<p>paragraph</p>\n")
    end
  end

  describe "Helper.fields_with_modifiers" do
    it "should return an empty array when nil" do
      expect(Template::Helper.fields_with_modifiers(nil)).to eq([])
    end
    it "should parse simple markdown" do
      template = TemplateTestImpl.new
      template.contents = "{{voornaam.hoofdletter.hoofdletters}} {{achternaam.hoofdletter}} {{gewoon}}  {{gewoon.hoofdletter}}"
      expect(Template::Helper.fields_with_modifiers(template.contents)).to eq([
        {field: "voornaam", mods: ["hoofdletter", "hoofdletters"]},
        {field: "achternaam", mods: ["hoofdletter"]},
        {field: "gewoon", mods: []},
        {field: "gewoon", mods: ["hoofdletter"]}
      ])
      expect(template.fields).to eq(["voornaam", "achternaam", "gewoon"])
    end
  end

  describe "#object_calls_with_modifiers" do
    it "should return an empty array when nil" do
      expect(Template::Helper.object_calls_with_modifiers(nil)).to eq([])
    end
    it "should parse simple markdown" do
      template = TemplateTestImpl.new
      template.contents = "{{voornaam.hoofdletter.hoofdletters}} {{achternaam.hoofdletter}} {{Datum.vandaag}}  {{gewoon.hoofdletter}}"
      expect(Template::Helper.object_calls_with_modifiers(template.contents)).to eq([{object: "Datum", method: "vandaag", mods: []}])
    end
  end

  describe "#content_merge" do
    it "should return an empty string when nil" do
      expect(TemplateTestImpl.new.content_merge).to eq("")
      expect(TemplateTestImpl.new.content_merge({"achternaam" => "jan", "voornaam" => "kees", "gewoon" => "gewoon"})).to eq("")
    end
    it "should parse string" do
      template = TemplateTestImpl.new
      template.contents = "{{voornaam.hoofdletter.hoofdletters}} {{achternaam.hoofdletter}} {{gewoon.hoofdletter}}"
      expect(template.content_merge({"achternaam" => "jan", "voornaam" => "kees", "gewoon" => "gewoon"})).to eq("KEES Jan Gewoon")
    end
    it "should parse string with obects" do
      template = TemplateTestImpl.new
      template.contents = "\n{{voornaam.hoofdletter.hoofdletters}} {{achternaam.hoofdletter}} {{Datum.vandaag}} {{gewoon.hoofdletter}}"
      expect(template.content_merge({"achternaam" => "jan", "voornaam" => "kees", "gewoon" => "gewoon"})).to eq("\n<p>KEES Jan #{I18n.l Time.current.to_date, format: :long} Gewoon</p>\n")
    end
  end
end
