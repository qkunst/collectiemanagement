# frozen_string_literal: true

require "rails_helper"

RSpec.describe SystemMailer, type: :mailer do
  describe "error_message" do
    let(:mail) { SystemMailer.error_message(StandardError.new) }

    it "renders the headers" do
      expect(mail.subject).to eq("StandardError fout in #{I18n.t("application.name")}")
      expect(mail.to).to eq(["qkunst@murb.nl"])
      expect(mail.from).to eq(["collectiemanagement@qkunst.nl"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("StandardError")
    end
  end
end
