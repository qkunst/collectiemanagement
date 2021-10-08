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
end
