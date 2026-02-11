# frozen_string_literal: true

require "rails_helper"

RSpec.describe Works::TitleLabels do
  subject(:service) do
    described_class.new(
      collection:,
      works:,
      qr_code_enabled:,
      resource_variant:,
      foreground_color:,
      show_logo:,
      a4print:
    )
  end

  let(:collection) { instance_double(Collection, unique_short_code_from_self_or_base: "COL") }
  let(:base_domain) { "https://ppid.example/" }
  let(:logo_path_value) { "logo.svg" }
  let(:logo_file) { instance_double(File, path: logo_path_value) }
  let(:labels_types) { {} }
  let(:document_double) { instance_double("Prawn::Document", render: "pdf-output") }
  let(:labels_instance) { instance_double("Prawn::Labels::Instance", document: document_double) }

  let(:pdf_bounds) { double("Bounds", width: 200, height: 100) }
  let(:pdf) { double("Prawn::Document", bounds: pdf_bounds) }

  let(:work) do
    instance_double(
      Work,
      id: 123,
      stock_number: "STOCK-123",
      title_rendered: "Untitled",
      object_creation_year: 1999
    ).tap do |instance|
      allow(instance).to receive(:artist_name_rendered).with(name_order: :human).and_return("Jane Doe")
    end
  end
  let(:works) { [work] }

  let(:qr_code_enabled) { false }
  let(:resource_variant) { nil }
  let(:foreground_color) { nil }
  let(:show_logo) { false }
  let(:a4print) { nil }

  before do
    allow(Rails.application).to receive(:config_for).with(:config).and_return(ppid_base_domain: base_domain)
    allow(File).to receive(:open).and_return(logo_file)
    allow(Prawn::Labels).to receive(:types).and_return(labels_types)

    allow(pdf).to receive(:bounding_box).and_yield
    allow(pdf).to receive(:text)
    allow(pdf).to receive(:svg)
    allow(pdf).to receive(:image)
    allow(pdf).to receive(:qrcode)
  end

  def expect_labels_invocation(expected_works:, layout:)
    expect(Prawn::Labels).to receive(:new).with(
      expected_works,
      type: "A7",
      document: {page_layout: layout}
    ) do |*_args, &block|
      expected_works.each { |w| block.call(pdf, w) }
      labels_instance
    end
  end

  describe "#render" do
    it "sets up an A4 portrait label sheet by default and returns the PDF bytes" do
      expect_labels_invocation(expected_works: works, layout: :portrait)

      result = nil
      expect { result = service.render }.to change { labels_types["A7"] }.from(nil).to(
        {
          "columns" => 2,
          "rows" => 4,
          "paper_size" => "A4",
          "left_margin" => 0,
          "right_margin" => 0,
          "top_margin" => 0,
          "bottom_margin" => 0,
          "column_gutter" => 0,
          "row_gutter" => 0
        }
      )

      expect(result).to eq("pdf-output")
      expect(service.foreground_color).to eq("000000")
      expect(service.a4print).to be(true)
      expect(service.works).to eq(works)
      expect(pdf).not_to have_received(:qrcode)
    end

    context "when QR codes are enabled" do
      let(:qr_code_enabled) { true }
      let(:a4print) { false }
      let(:foreground_color) { "12abef" }
      let(:resource_variant) { "detail" }

      let(:work_without_stock) do
        instance_double(
          Work,
          id: 9,
          stock_number: nil,
          title_rendered: "Other work",
          object_creation_year: 2001
        ).tap do |instance|
          allow(instance).to receive(:artist_name_rendered).with(name_order: :human).and_return("Other")
        end
      end
      let(:works) { [work, work_without_stock] }

      it "filters out works without stock numbers, switches layout, and renders QR codes" do
        expect(pdf).to receive(:qrcode).with(
          "https://ppid.example/COL/STOCK-123.detail",
          color: "12abef"
        )

        expect_labels_invocation(expected_works: [work], layout: :landscape)

        service.render

        expect(labels_types["A7"]).to eq(
          {
            "columns" => 1,
            "rows" => 1,
            "paper_size" => "A7",
            "left_margin" => 0,
            "right_margin" => 0,
            "top_margin" => 0,
            "bottom_margin" => 0,
            "column_gutter" => 0,
            "row_gutter" => 0
          }
        )
        expect(service.works).to eq([work])
      end
    end

    context "when a logo should be rendered as SVG" do
      let(:show_logo) { true }
      let(:svg_markup) { "<svg width=\"10\"></svg>" }

      it "injects the foreground color before drawing the SVG" do
        expect_labels_invocation(expected_works: works, layout: :portrait)

        expect(File).to receive(:read).with(logo_file).and_return(svg_markup)
        expect(pdf).to receive(:svg).with(
          "<svg fill=\"#000000\" stroke=\"#000000\" width=\"10\"></svg>",
          hash_including(
            height: pdf_bounds.height / 2,
            valign: :bottom,
            align: :center,
            fill_color: "000000"
          )
        )
        expect(pdf).not_to receive(:image)

        service.render
      end
    end

    context "when the logo is not an SVG file" do
      let(:show_logo) { true }
      let(:logo_path_value) { "logo.png" }

      it "delegates to pdf.image with the provided file handle" do
        expect_labels_invocation(expected_works: works, layout: :portrait)

        expect(File).not_to receive(:read)
        expect(pdf).to receive(:image).with(
          logo_file,
          width: pdf_bounds.width,
          valign: :bottom,
          align: :center
        )
        expect(pdf).not_to receive(:svg)

        service.render
      end
    end
  end
end
