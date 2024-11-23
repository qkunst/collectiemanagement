class Collections::NumberLabels
  include ActiveModel::Model

  attr_accessor :offset, :amount, :collection, :subtext, :type

  def render
    prefix = collection.unique_short_code
    code = collection.unique_short_code
    collection.base_collection.name
    base_url = "https://ppid.qkunst.nl"
    logo_path = nil # File.open(Rails.root.join("app", "assets", "images", "logo.svg")) # this still needs improvement

    numbers = amount.times.to_a.map { |i| "#{prefix}#{(offset + i).to_s.rjust(4, "0")}" }
    title = collection.base_collection.name

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

    Prawn::Labels.new(numbers, type: type || "A8") do |pdf, number|
      url = URI.join(base_url, "#{code}/", number).to_s
      puts url
      margin = 5

      pdf.bounding_box([margin, pdf.bounds.top - margin], width: pdf.bounds.width - (2 * margin), height: pdf.bounds.height - (2 * margin)) do
        row_height = (pdf.bounds.height / 2)
        col_width = (pdf.bounds.width / 3)

        pdf.bounding_box([0, pdf.bounds.height], width: pdf.bounds.width, height: row_height) do
          pdf.text "Eigendom/Owner:", size: 2.5
          if logo_path&.path&.end_with? ".svg"
            pdf.svg File.read(logo_path), width: pdf.bounds.width, height: pdf.bounds.height, valign: :centerex
          elsif logo_path
            pdf.image logo_path, width: pdf.bounds.width, valign: :centerex # , at: [pdf.bounds.width - logo_width, pdf.bounds.height], valign: :middle
          else
            pdf.text "\n", size: 2.5
            pdf.text title, size: 5
          end
        end
        pdf.bounding_box([0, row_height], width: col_width, height: row_height) do
          pdf.qrcode url
        end
        pdf.bounding_box([col_width + margin, row_height], width: col_width * 2 - margin, height: row_height) do
          pdf.formatted_text [
            {text: number + "\n", size: 7},
            {text: "\n" + subtext, size: 2.5}

          ], valign: :bottom
        end
      end
    end.document.render
  end
end
