# frozen_string_literal: true

module Work::SizingRendering
  extend ActiveSupport::Concern
  MAX_ACCEPTABLE_DEPTH_FOR_2D = 10 # 10cm

  included do
    def frame_size
      whd_to_s(frame_width, frame_height, frame_depth, frame_diameter)
    end

    def frame_size_with_fallback
      frame_size || work_size
    end

    def hpd_height
      rv = frame_height? ? frame_height : height
      rv if rv && (rv > 0)
    end

    def hpd_width
      rv = frame_width? ? frame_width : width
      rv if rv && (rv > 0)
    end

    def hpd_depth
      rv = frame_depth? ? frame_depth : depth
      rv if rv && (rv > 0)
    end

    def hpd_diameter
      rv = frame_diameter? ? frame_diameter : diameter
      rv if rv && (rv > 0)
    end

    def three_dimensional?
      !!(hpd_depth && hpd_depth > MAX_ACCEPTABLE_DEPTH_FOR_2D || hpd_diameter)
    end

    def floor_bound?
      three_dimensional?
    end

    # return in meters
    def wall_surface
      if !floor_bound? && hpd_width && hpd_height
        (hpd_width * hpd_height) / 10000.0
      end
    end

    # return in meters
    def floor_surface
      if floor_bound? && hpd_width && hpd_depth
        (hpd_width * hpd_depth) / 10000.0
      elsif floor_bound? && hpd_diameter
        (hpd_diameter * hpd_diameter) / 10000.0
      end
    end

    def surfaceless?
      !floor_surface && !wall_surface
    end

    def object_format_code
      size = [hpd_height, hpd_width, hpd_depth, hpd_diameter].compact.max
      if !size
      elsif size < 30
        :xs
      elsif size < 50
        :s
      elsif size < 80
        :m
      elsif size < 120
        :l
      elsif size < 1000
        :xl
      elsif size >= 1000
        :xxl
      end
    end

    def whd_to_s width = nil, height = nil, depth = nil, diameter = nil
      whd_values = [width, height, depth].collect { |a| dimension_to_s(a) }.compact
      rv = whd_values.join(" × ")
      if whd_values.count > 0
        legend = []
        legend << "b" unless width.to_s == ""
        legend << "h" unless height.to_s == ""
        legend << "d" unless depth.to_s == ""
        rv = "#{rv} (#{legend.join("×")})"
      end
      rv = [rv, "⌀ #{dimension_to_s(diameter)}"].compact.join("; ") if dimension_to_s(diameter)
      return nil if rv.empty?
      rv
    end

    def work_size
      whd_to_s(width, height, depth, diameter)
    end

  end
end
