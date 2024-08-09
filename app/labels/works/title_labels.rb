class Works::TitleLabels
  include ActiveModel::Model
  include LabelsSupport

  attr_accessor :collection, :works, :qr_code_enabled, :resource_variant

  def render
    code = collection.unique_short_code || collection.base_collection.unique_short_code
    base_url = Rails.application.config_for(:config)[:ppid_base_domain]
    logo_path = File.open(Rails.root.join("app", "assets", "images", "logo.svg"))

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
    }

    Prawn::Labels.new(works, type: "A7") do |pdf, work|
      number = work.stock_number
      url = URI.join(base_url, "#{code}/", number).to_s
      url = [url, resource_variant].compact.join(".")
      margin = 5
      grid = Grid.new(columns: 4, rows: 4, outer_width: pdf.bounds.width, outer_height: pdf.bounds.height, margin:)

      pdf.bounding_box(*grid.bounding_box) do
        pdf.bounding_box(*grid.area_bounding_box([0, 1], [3, 2])) do
          pdf.text work.artist_name_rendered, size: 10, weight: 500
          pdf.text " ", size: 5, weight: 500
          pdf.text work.title, size: 15
          pdf.text " ", size: 5, weight: 500
          pdf.text work.object_creation_year.to_s, size: 12, weight: 500
        end
        pdf.bounding_box(*grid.area_bounding_box([0, 0], [1, 0])) do
          if logo_path&.path&.end_with? ".svg"
            pdf.svg File.read(logo_path), height: (pdf.bounds.height / 2), valign: :bottom, align: :center
          elsif logo_path
            pdf.image logo_path, width: pdf.bounds.width, valign: :bottom, align: :center # , at: [pdf.bounds.width - logo_width, pdf.bounds.height], valign: :middle
          else
            pdf.text "\n", size: 5
            pdf.text title, size: 15
          end
        end

        if qr_code_enabled
          pdf.bounding_box(*grid.area_bounding_box([3, 3])) do
            pdf.qrcode(url, align: :right, valign: :bottom)
          end
        end
      end
    end.document.render
  end
end
