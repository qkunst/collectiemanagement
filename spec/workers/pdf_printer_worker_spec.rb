# frozen_string_literal: true

require "rails_helper"

RSpec.describe PdfPrinterWorker, type: :model do
  it "cleans the resource" do
    expect { PdfPrinterWorker.new.clean_resource("/tmp/CTyg9VGYtY3FM5fLon5wcTdkueGtN9t3.html") }.not_to raise_error

  end

  it "works for /" do
    user = users(:admin)

    expect { PdfPrinterWorker.new.perform(Rails.root.join("public", "404.html").to_s, {inform_user_id: user.id}) }.to change(Message, :count).by(1)

    message = Message.last

    expect(message.subject).to eq("PDF gereed")
    expect(message.attachment.file.path).to end_with(".pdf")

    pdf_contents = File.read(message.attachment.file.path).encode("UTF-8", invalid: :replace, undef: :replace)
    expect(pdf_contents).to include("BoldItalic") # poor man's pdf test, this is not present when the filename is rendered.
  end
end
