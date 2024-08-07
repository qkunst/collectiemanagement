# frozen_string_literal: true

require "rails_helper"

RSpec.describe LabelsSupport do
  describe LabelsSupport::Grid do
    describe "3 x 3" do
      let(:grid) { LabelsSupport::Grid.new(outer_width: 610, outer_height: 310, columns: 3, rows: 3, margin: 5) }

      it "returns the right bounding box" do
        expect(grid.bounding_box).to eq([[5, 305], width: 600, height: 300])
      end

      it "has the cells correctly sorted" do
        expect(grid.cells.map { |row| row.map { |c| [[c.x, c.y], [c.x_max, c.y_max]] } }).to eq(
          [[[[0, 200], [200, 300]], [[200, 200], [400, 300]], [[400, 200], [600, 300]]],
            [[[0, 100], [200, 200]], [[200, 100], [400, 200]], [[400, 100], [600, 200]]],
            [[[0, 0], [200, 100]], [[200, 0], [400, 100]], [[400, 0], [600, 100]]]]
        )
      end

      it "returns the right bounding box for a range of cells" do
        a = grid.area_bounding_box([0, 0], [0, 0])
        a_var = grid.area_bounding_box([0, 0], [0, 0])
        # a--
        # ---
        # ---
        b = grid.area_bounding_box([0, 0], [2, 2])
        # bbb
        # bbb
        # bbb
        c = grid.area_bounding_box([1, 0], [1, 1])
        # -c-
        # -c-
        # ---
        d = grid.area_bounding_box([2, 2], [2, 2])
        d_var = grid.area_bounding_box([2, 2])
        # ---
        # ---
        # --d
        expect(a).to eq([[0, 300], {width: 200, height: 100}])
        expect(a).to eq(a_var)
        expect(b).to eq([[0, 300], {width: 600, height: 300}])
        expect(c).to eq([[200, 300], {width: 200, height: 200}])
        expect(d).to eq([[400, 100], {width: 200, height: 100}])
        expect(d).to eq(d_var)
      end

      describe "4x4" do
        let(:grid) { LabelsSupport::Grid.new(outer_width: 410, outer_height: 810, columns: 4, rows: 4, margin: 5) }

        it "has width and height" do
          expect(grid.width).to eq(400)
          expect(grid.height).to eq(800)
        end
        it "has the cells correctly sorted" do
          expect(grid.cells.map { |row| row.map { |c| [[c.x, c.y_max], [c.x_max, c.y]] } }).to eq(
            [[[[0, 800], [100, 600]], [[100, 800], [200, 600]], [[200, 800], [300, 600]], [[300, 800], [400, 600]]],
              [[[0, 600], [100, 400]], [[100, 600], [200, 400]], [[200, 600], [300, 400]], [[300, 600], [400, 400]]],
              [[[0, 400], [100, 200]], [[100, 400], [200, 200]], [[200, 400], [300, 200]], [[300, 400], [400, 200]]],
              [[[0, 200], [100, 0]], [[100, 200], [200, 0]], [[200, 200], [300, 0]], [[300, 200], [400, 0]]]]
          )
        end
      end
    end
  end
end
