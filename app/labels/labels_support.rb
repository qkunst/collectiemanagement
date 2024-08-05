module LabelsSupport
  class Cell
    include ActiveModel::Model

    attr_accessor :width
    attr_accessor :height
    attr_accessor :column
    attr_accessor :row

    def x = column * width

    def y = row * height

    def x_max = x + width

    def y_max = y + height
  end

  class Grid
    include ActiveModel::Model

    attr_accessor :outer_width
    attr_accessor :outer_height
    attr_accessor :rows
    attr_accessor :columns
    attr_accessor :margin

    # |    |    |    |
    # ----------------
    # |    |    |    |
    # ----------------
    # |    |    |    |

    def row_height = (height / 3)

    def col_width = (width / 3)

    def width = (outer_width - (2 * margin))

    def height = (outer_height - (2 * margin))

    def cells
      @cells ||= rows.times.collect do |row|
        columns.times.collect do |column|
          Cell.new(column: column, row: row, height: row_height, width: col_width)
        end
      end.reverse
    end

    def bounding_box
      [[margin, (outer_height - margin)], width:, height:]
    end

    def area_bounding_box(top_left, bottom_right = nil)
      top_left_cell = cells[top_left[1]][top_left[0]]
      bottom_right_cell = bottom_right ? (cells[bottom_right[1]][bottom_right[0]]) : top_left_cell
      [[top_left_cell.x, top_left_cell.y_max], width: (bottom_right_cell.x_max - top_left_cell.x), height: (top_left_cell.y_max - bottom_right_cell.y)]
    end
  end
end
