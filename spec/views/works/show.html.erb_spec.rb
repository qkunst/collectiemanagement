# frozen_string_literal: true

require "rails_helper"

RSpec.describe "works/show", type: :view do
  include Devise::Test::ControllerHelpers

  it "renders attributes" do
    @collection = collections(:collection1)
    @selection = {display: :complete}
    @work = assign(:work, Work.create!(
      title: "Work",
      alt_number_1: "aul07<script>alert(1)</script>kviak",
      alt_number_2: "aul07<script>alert(1)</script>kviak",
      alt_number_3: "aul07<script>alert(1)</script>kviak",
      description: "aul07<script>alert(1)</script>kviak",
      information_back: "aul07<script>alert(1)</script>kviak",
      medium_comments: "aul07<script>alert(1)</script>kviak",
      print: "aul07<script>alert(1)</script>kviak",
      signature_comments: "aul07<script>alert(1)</script>kviak",
      collection: @collection
    ))
    sign_in users(:admin)
    @custom_reports = []
    render
    expect(rendered).not_to match(/<script>alert\(1\)<\/script>/)
    expect(rendered).to match(/aul07alert\(1\)kviak/)
  end

  it "renders display price" do
    sign_in users(:admin)

    @collection = collections(:collection1)
    @selection = {display: :complete}
    @custom_reports = []
    @work = works(:work1)
    @work.purchase_price_currency.symbol = nil

    render

    expect(rendered).to match("100")
  end

  describe "display modes" do
    let(:display) { :complete }
    before(:each) do
      @selection = {display: display}
      @work = works(:work1)
      @collection = collections(:collection1)
      assign(:work, @work)
      sign_in users(:admin)
      @custom_reports = []
      render
    end

    context(:complete) do
      it "renders correctly" do
        expect(rendered).to match("Interne opmerking bij werk 1")
        expect(rendered).to match("Marktwaarde")
      end
    end

    context(:detailed) do
      let(:display) { :detailed }

      it "renders correctly" do
        expect(rendered).not_to match("Interne opmerking bij werk 1")
        expect(rendered).to match("Marktwaarde")
      end
    end

    context(:detailed_discreet) do
      let(:display) { :detailed_discreet }

      it "renders correctly" do
        expect(rendered).not_to match("Interne opmerking bij werk 1")
        expect(rendered).not_to match("Marktwaarde")
      end
    end
  end

  it "renders attachments" do
    @collection = collections(:collection1)
    @selection = {display: :complete}
    @work = works(:work_with_attachments)
    @custom_reports = []
    sign_in users(:admin)

    render
    expect(rendered).to match(/Work with attachment/)
    expect(rendered).to match(/unpredictableattachmentname/)
  end
end
