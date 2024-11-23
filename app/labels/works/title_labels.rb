class Works::TitleLabels
  include ActiveModel::Model
  include LabelsSupport

  attr_accessor :collection, :works, :qr_code_enabled, :resource_variant, :foreground_color

  def render
    code = collection.unique_short_code_from_self_or_base
    base_url = Rails.application.config_for(:config)[:ppid_base_domain]
    logo_path = File.open(Rails.root.join("app", "assets", "images", "logo.svg"))
    self.foreground_color ||= "000000"

    self.works = works.to_a.select { |w| w.stock_number } if qr_code_enabled

    Prawn::Labels.types["A7"] = {
      "columns" => 2,
      "rows" => 4,
      "paper_size" => "A4",
      "left_margin" => 0,
      "right_margin" => 0,
      "top_margin" => 0,
      "bottom_margin" => 0,
      "column_gutter" => 0,
      "row_gutter" => 0
    }.freeze

    Prawn::Labels.new(works, type: "A7") do |pdf, work|
      number = work.stock_number || "DB#{work.id.to_s.rjust(8, "0")}"
      url = URI.join(base_url, "#{code}/", number).to_s
      url = [url, resource_variant].compact.join(".")
      margin = 5
      grid = Grid.new(columns: 4, rows: 4, outer_width: pdf.bounds.width, outer_height: pdf.bounds.height, margin:)

      pdf.bounding_box(*grid.bounding_box) do
        pdf.bounding_box(*grid.area_bounding_box([0, 1], [3, 2])) do
          pdf.text work.artist_name_rendered(name_order: :human), size: 15, color: foreground_color
          pdf.text " ", size: 5, weight: 500
          pdf.text work.title_rendered, size: 10, weight: 500, color: foreground_color
          pdf.text " ", size: 5, weight: 500
          pdf.text work.object_creation_year.to_s, size: 12, weight: 500, color: foreground_color
        end
        pdf.bounding_box(*grid.area_bounding_box([0, 0], [1, 0])) do
          if logo_path&.path&.end_with? ".svg"
            svg_contents = File.read(logo_path)
            svg_contents = svg_contents.sub("<svg ", "<svg fill=\"##{foreground_color}\" stroke=\"##{foreground_color}\" ")
            pdf.svg svg_contents, height: (pdf.bounds.height / 2), valign: :bottom, align: :center, fill_color: foreground_color
          elsif logo_path
            pdf.image logo_path, width: pdf.bounds.width, valign: :bottom, align: :center # , at: [pdf.bounds.width - logo_width, pdf.bounds.height], valign: :middle
          else
            pdf.text "\n", size: 5
            pdf.text title, size: 15
          end
        end

        if qr_code_enabled
          pdf.bounding_box(*grid.area_bounding_box([3, 3])) do
            pdf.qrcode(url, color: foreground_color)
          end
        end
      end
    end.document.render
  end
end
