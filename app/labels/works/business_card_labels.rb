class Works::BusinessCardLabels
  include ActiveModel::Model
  include LabelsSupport

  attr_accessor :collection, :works, :qr_code_enabled, :resource_variant, :foreground_color, :show_logo, :a4print

  def sanitize text
    @sanitizer_class ||= Rails::HTML5::FullSanitizer.new
    @sanitizer_class.sanitize(text)
  end

  def render
    code = collection.unique_short_code_from_self_or_base
    base_url = Rails.application.config_for(:config)[:ppid_base_domain]
    self.foreground_color ||= "000000"

    self.works = works.to_a.select { |w| w.stock_number } if qr_code_enabled

    # [155.91 240.94] == 55mm x 85mm (multiplier 0.3527777778)
    Prawn::Labels.types["business_card_eu"] = {
      "columns" => a4print ? 2 : 1,
      "rows" => a4print ? 3 : 1,
      "paper_size" => a4print ? "A4" : [155.91, 240.94],
      "orientation" => :landscape,
      "left_margin" => 0,
      "right_margin" => 0,
      "top_margin" => 0,
      "bottom_margin" => 0,
      "column_gutter" => 0,
      "row_gutter" => 0
    }.freeze

    Prawn::Labels.new(works, type: "business_card_eu", document: {page_layout: (a4print ? :portrait : :landscape)}) do |pdf, work|
      number = work.stock_number || "DB#{work.id.to_s.rjust(8, "0")}"
      margin = 15
      grid = Grid.new(columns: 12, rows: 8, outer_width: pdf.bounds.width, outer_height: pdf.bounds.height, margin:)

      pdf.bounding_box(*grid.bounding_box) do
        pdf.bounding_box(*grid.area_bounding_box([6, 0], [11, 7])) do
          artist = "<font size='12'>#{sanitize(work.artist_name_rendered(name_order: :human, include_years: false))}</font>"
          title = "<font size='9'><i>#{sanitize(work.title_rendered)}</i></font>"
          year = "<font size='9'>(#{work.object_creation_year})</font>" if work.object_creation_year
          pdf.text [artist, title, year].compact.join("<br/>"), valign: :bottom, inline_format: true, leading: 3, size: 9
        end

        if qr_code_enabled
          url = URI.join(base_url, "#{code}/", number).to_s
          url = [url, resource_variant].compact.join(".")
          pdf.bounding_box(*grid.area_bounding_box([0, 2], [4, 7], offset: [0, -2])) do
            pdf.qrcode(url, color: foreground_color, valign: :bottom)
          end
        end
      end
    end.document.render
  end
end
