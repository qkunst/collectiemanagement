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
    it "doesn't render javascript" do
      # the code uses the sanitize method; which is considered to be safe; these test just test whether basic sanitazion takes place
      expect(helper.kramdown("<script>alert('hey');</script>")).to eq("alert('hey');\n\n")
      expect(helper.kramdown('<a href="/internal_link" onclick="document.location=\'evilsite.com\'">')).to eq("<p><a href=\"/internal_link\"></a></p>\n")
    end
  end

  describe "#data_to_hidden_inputs" do
    it "renders key-value" do
      expect(helper.data_to_hidden_inputs({fieldname: 1})).to eq('<input type="hidden" name="fieldname" id="fieldname" value="1" autocomplete="off" />')
    end
    it "renders array" do
      expect(helper.data_to_hidden_inputs({fieldname: [1, 2]})).to eq(['<input type="hidden" name="fieldname[]" id="fieldname_" value="1" autocomplete="off" />', '<input type="hidden" name="fieldname[]" id="fieldname_" value="2" autocomplete="off" />'].join("\n"))
    end
    it "renders nested structure" do
      expect(helper.data_to_hidden_inputs({fieldname: {nested: [1, 2], other: {nested: 3}}})).to eq([
        '<input type="hidden" name="fieldname[nested][]" id="fieldname_nested_" value="1" autocomplete="off" />',
        '<input type="hidden" name="fieldname[nested][]" id="fieldname_nested_" value="2" autocomplete="off" />',
        '<input type="hidden" name="fieldname[other][nested]" id="fieldname_other_nested" value="3" autocomplete="off" />'
      ].join("\n"))
    end
  end
end
