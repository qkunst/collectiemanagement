require_relative "../../rails_helper"

RSpec.describe Work::SizingRendering do
  describe "#three_dimensional?" do
    it "returns false for an empty work" do
      expect(Work.new.three_dimensional?).to eq(false)
    end

    it "returns false for a 2d work" do
      expect(Work.new(width: 20, height: 20).three_dimensional?).to eq(false)
    end

    it "returns false for a 2d work with a 9cm deep frame" do
      expect(Work.new(width: 20, height: 20, frame_depth: 9).three_dimensional?).to eq(false)
    end

    it "returns false for a 3d work" do
      expect(Work.new(width: 20, height: 20, frame_depth: 19).three_dimensional?).to eq(true)
      expect(Work.new(frame_width: 20, frame_height: 20, frame_diameter: 19).floor_bound?).to eq(true)
    end
  end

  describe "#floor_bound?" do
    it "returns false for an empty work" do
      expect(Work.new.floor_bound?).to eq(false)
    end

    it "returns false for a 2d work" do
      expect(Work.new(width: 20, height: 20).floor_bound?).to eq(false)
    end

    it "returns false for a 2d work with a 9cm deep frame" do
      expect(Work.new(width: 20, height: 20, frame_depth: 9).floor_bound?).to eq(false)
    end

    it "returns false for a 3d work" do
      expect(Work.new(width: 20, height: 20, frame_depth: 19).floor_bound?).to eq(true)
      expect(Work.new(width: 20, height: 20, frame_diameter: 19).floor_bound?).to eq(true)
    end
  end

  describe "#wall_surface" do
    it "returns false for an empty work" do
      expect(Work.new.wall_surface).to eq(nil)
    end

    it "returns square meter for a 2d work" do
      expect(Work.new(width: 20, height: 20).wall_surface).to eq(0.04)
    end

    it "returns square meter for a 2d work" do
      expect(Work.new(width: 100, height: 100).wall_surface).to eq(1)
    end

    it "returns nil for a 3d work" do
      expect(Work.new(width: 20, height: 20, frame_depth: 19).wall_surface).to eq(nil)
      expect(Work.new(width: 20, height: 20, frame_diameter: 19).wall_surface).to eq(nil)
    end
  end

  describe "#wall_surface" do
    it "returns nil for an empty work" do
      expect(Work.new.floor_surface).to eq(nil)
    end

    it "returns nil  for a 2d work" do
      expect(Work.new(width: 20, height: 20).floor_surface).to eq(nil)
    end

    it "returns values for a 3d work" do
      expect(Work.new(width: 20, height: 20, frame_depth: 40).floor_surface).to eq(0.08)
      expect(Work.new(width: 100, height: 2, frame_diameter: 100).floor_surface).to eq(1)
    end
  end

  describe "#surfaceless?" do
  end

  describe "#object_format_code" do
    it "should return proper format code" do
      expect(works(:work2).object_format_code).to eq(nil)
      w = works(:work2)
      w.height = 200
      expect(w.object_format_code).to eq(:xl)
      w.height = 90
      expect(w.object_format_code).to eq(:l)
    end
  end

  describe ".whd_to_s" do
    it "should render nil if all are nil" do
      expect(Work.new.send(:whd_to_s)).to eq(nil)
    end
    it "should render w x h x d if set" do
      expect(Work.new.send(:whd_to_s, 1, 2, 3)).to eq("2 × 1 × 3 (h×b×d)")
    end
    it "should round w x h x d" do
      expect(Work.new.send(:whd_to_s, 1.002345, 2.2323543, 3.777777)).to eq("2,2324 × 1,0023 × 3,7778 (h×b×d)")
    end
    it "should add diameter if set" do
      expect(Work.new.send(:whd_to_s, 1, 2, 3, 4)).to eq("2 × 1 × 3 (h×b×d); ⌀ 4")
    end
    it "should add diameter if set" do
      expect(Work.new.send(:whd_to_s, 1, nil, 3, 4)).to eq("1 × 3 (b×d); ⌀ 4")
    end
  end

  describe ".frame_size" do
    it "should use whd_to_s" do
      expect(Work.new(frame_width: 1, frame_height: nil, frame_depth: 3, frame_diameter: 4).frame_size).to eq("1 × 3 (b×d); ⌀ 4")
    end
  end

  describe "#work_size" do
    it "should return work size" do
      w = works(:work2)
      w.height = 90
      w.width = 180
      expect(works(:work2).work_size).to eq("90 × 180 (h×b)")
      w.depth = 10
      expect(works(:work2).work_size).to eq("90 × 180 × 10 (h×b×d)")
      w.diameter = 10
      expect(works(:work2).work_size).to eq("90 × 180 × 10 (h×b×d); ⌀ 10")
    end
  end

  describe "#work_size" do
    it "should return work size" do
      w = works(:work2)
      w.height = 90
      w.width = 180
      w.frame_height = 100
      w.frame_width = 190
      expect(works(:work2).frame_size).to eq("100 × 190 (h×b)")
    end
  end

  describe "#frame_size_with_fallback" do
    it "should return frame size by default" do
      expect(works(:work1).frame_size_with_fallback).to eq(works(:work1).frame_size)
      expect(works(:work2).frame_size_with_fallback).to eq(nil)
    end

    it "should return work size if frame size is not present" do
      w = works(:work2)
      w.height = 90
      w.width = 180
      expect(works(:work2).frame_size_with_fallback).to eq("90 × 180 (h×b)")
    end
  end

end
