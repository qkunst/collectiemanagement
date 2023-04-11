# frozen_string_literal: true

require "rails_helper"

RSpec.describe UitleenHelper, type: :helper do
  describe "#uitleen_work_url" do
    let(:work) { works(:work1) }

    before do
      Rails.application.secrets.uitleen_site = nil
    end

    it "return nil by default" do
      expect(uitleen_work_url(work)).to eq(nil)
    end

    context "uitleen site set" do
      before do
        Rails.application.secrets.uitleen_site = "http://uitleen.localhost"
      end

      it "returns a work url in uitleen if uitleen config is present" do
        Rails.application.secrets.uitleen_site = "http://uitleen.localhost"
        expect(uitleen_work_url(work)).to eq("http://uitleen.localhost/collections/#{work.collection_id}/works/#{work.id}")
      end
    end
  end

  describe "#uitleen_new_draft_invoice_url" do
    let(:work_set) { work_sets(:work_set_collection1) }
    let(:params) { {invoiceable_item_collection: work_set} }

    before do
      Rails.application.secrets.uitleen_site = nil
    end

    it "returns nil by default" do
      expect(uitleen_new_draft_invoice_url).to eq(nil)
      expect(uitleen_new_draft_invoice_url(params)).to eq(nil)
    end

    context "uitleen site set" do
      before do
        Rails.application.secrets.uitleen_site = "http://uitleen.localhost"
      end

      it "returns a new url with no params" do
        expect(uitleen_new_draft_invoice_url).to eq("http://uitleen.localhost/draft_invoices/new?")
      end

      it "returns a new url with params when given" do
        expect(uitleen_new_draft_invoice_url({a: 2})).to eq("http://uitleen.localhost/draft_invoices/new?a=2")
        expect(uitleen_new_draft_invoice_url(params)).to eq("http://uitleen.localhost/draft_invoices/new?invoiceable_item_collection_external_id=#{work_set.uuid}&invoiceable_item_collection_type=CollectionManagement%3A%3AWorkSet")
      end
    end
  end
end
