# frozen_string_literal: true

require "rails_helper"

RSpec.describe JsonHelper, type: :helper do
  describe "render_hash" do
    it "should return an nothing when empty" do
      expect(helper.render_hash(nil)).to eq("")
      expect(helper.render_hash("")).to eq("")
      expect(helper.render_hash("just a string")).to eq("just a string")
      expect(helper.render_hash(123)).to eq("123")
    end
    it "should return a list when given a list" do
      expect(helper.render_hash([1, 2, 3])).to eq("<ul><li>1</li><li>2</li><li>3</li></ul>")
    end
    it "should return a dl if kvs" do
      expect(helper.render_hash({a: 1, b: "second letter"})).to eq("<dl><dt>A</dt><dd>1</dd><dt>B</dt><dd>second letter</dd></dl>")
    end
    it "should combine" do
      expect(helper.render_hash({a: nil, b: [1, "a"]})).to eq("<dl><dt>B</dt><dd><ul><li>1</li><li>a</li></ul></dd></dl>")
    end
  end
end
