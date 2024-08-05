class Works::TitleLabels
  include ActiveModel::Model
  include LabelsSupport

  attr_accessor :base_url, :collection, :works

  def render
    code = collection.unique_short_code
    base_url = "https://ppid.qkunst.nl"
    logo_path = File.open(Rails.root.join("app", "assets", "images", "logo.svg"))
    @works = @works[1..16]
    # logo_path = nil # File.open(Rails.root.join("app", "assets", "images", "logo.svg")) # this still needs improvement

    Prawn::Labels.types["A8"] = {
      "columns" => 4,
      "rows" => 4,
      "paper_size" => [297, 210],
      "left_margin" => 0,
      "right_margin" => 0,
      "top_margin" => 0,
      "bottom_margin" => 0,
      "column_gutter" => 0,
      "row_gutter" => 0
    }

    Prawn::Labels.new(works, type: "A8") do |pdf, work|
      number = work.stock_number
      url = URI.join(base_url, "#{code}/", number).to_s
      puts url
      margin = 5
      grid = Grid.new(columns: 3, rows: 3, outer_width: pdf.bounds.width, outer_height: pdf.bounds.height, margin:)

      pdf.bounding_box(*grid.bounding_box) do
        pdf.bounding_box(*grid.area_bounding_box([0, 0], [2, 1])) do
          pdf.text work.artist_name_rendered, size: 3, weight: 500
          pdf.text " ", size: 1.5, weight: 500
          pdf.text work.title, size: 4
        end
        pdf.bounding_box(*grid.area_bounding_box([0, 2], [1, 2])) do
          if logo_path&.path&.end_with? ".svg"
            pdf.svg File.read(logo_path), height: pdf.bounds.height, valign: :bottom, align: :center
          elsif logo_path
            pdf.image logo_path, width: pdf.bounds.width, valign: :bottom, align: :center # , at: [pdf.bounds.width - logo_width, pdf.bounds.height], valign: :middle
          else
            pdf.text "\n", size: 2.5
            pdf.text title, size: 5
          end
        end

        pdf.bounding_box(*grid.area_bounding_box([2, 2])) do
          pdf.qrcode url
        end
        pdf.bounding_box(*grid.area_bounding_box([2, 1])) do
          pdf.formatted_text [
            {text: number + "\n", size: 3}
          ], valign: :bottom, align: :center
        end
      end
    end.document.render
  end
end
