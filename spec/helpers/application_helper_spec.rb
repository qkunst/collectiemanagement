# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  describe "#menu_link_to" do
    it "returns takes a description and task" do
      allow(helper.request).to receive(:path).and_return "books"
      expect(helper.menu_link_to("description", "books/1")).to eq("<a class=\"\" href=\"books/1\">description</a>")
    end
    it "should mark equal path active" do
      allow(helper.request).to receive(:path).and_return "books/1"
      expect(helper.menu_link_to("description", "books/1")).to eq("<a class=\"active\" href=\"books/1\">description</a>")
    end
    it "should mark equal path active also with :only_exact_path_match-option true" do
      allow(helper.request).to receive(:path).and_return "books/1"
      expect(helper.menu_link_to("description", "books/1", {only_exact_path_match: true})).to eq("<a class=\"active\" href=\"books/1\">description</a>")
    end
    it "should mark child path active (by default)" do
      allow(helper.request).to receive(:path).and_return "books/1/page/1"
      expect(helper.menu_link_to("description", "books/1")).to eq("<a class=\"active\" href=\"books/1\">description</a>")
    end
    it "should not mark child path active if only_exact_path_match: true" do
      allow(helper.request).to receive(:path).and_return "books/1/page/1"
      expect(helper.menu_link_to("description", "books/1", {only_exact_path_match: true})).to eq("<a class=\"\" href=\"books/1\">description</a>")
    end
    it "should work with full urls as well" do
      allow(helper.request).to receive(:path).and_return "books/1/page/1"
      expect(helper.menu_link_to("description", "http://example.com/books/1")).to eq("<a class=\"active\" href=\"http://example.com/books/1\">description</a>")
    end
  end

  describe "#kramdown" do
    it "understands bold" do
      expect(helper.kramdown("**strong**")).to eq("<p><strong>strong</strong></p>\n")
    end
    it "doesn't parse tables" do
      expect(helper.kramdown("a | b")).to eq("<p>a | b</p>\n")
    end
  end
end
