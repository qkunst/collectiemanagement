# frozen_string_literal: true

module Work::SizingRendering
  extend ActiveSupport::Concern
  MAX_ACCEPTABLE_DEPTH_FOR_2D = 10 # 10cm

  included do
    def frame_size
      whd_to_s(frame_width, frame_height, frame_depth, frame_diameter)
    end

    def work_size
      whd_to_s(width, height, depth, diameter)
    end

    def frame_size_with_fallback
      frame_size || work_size
    end

    def height_with_fallback
      numeric_value_with_fallback(frame_height, height)
    end
    alias_method :hpd_height, :height_with_fallback

    def width_with_fallback
      numeric_value_with_fallback(frame_width, width)
    end
    alias_method :hpd_width, :width_with_fallback

    def depth_with_fallback
      numeric_value_with_fallback(frame_depth, depth)
    end
    alias_method :hpd_depth, :depth_with_fallback

    def diameter_with_fallback
      numeric_value_with_fallback(frame_diameter, diameter)
    end
    alias_method :hpd_diameter, :diameter_with_fallback

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

    def orientation
      if height_with_fallback && width_with_fallback && width_with_fallback > 0
        ratio = height_with_fallback / width_with_fallback

        if ratio == 1
          :square
        elsif ratio < 0.9
          :landscape
        elsif ratio > 1.1
          :portrait
        else
          :roughly_square
        end
      end

    end

    private

    # The correct order is length (L), width (W), height (H). As in (L) × (W) × (H) to find volume in both Imperial and Metric Units.
    # Verzoek QKunst: hoogte * breedte * diepte
    def whd_to_s width = nil, height = nil, depth = nil, diameter = nil
      whd_values = [height, width, depth].collect { |a| dimension_to_s(a) }.compact
      rv = whd_values.join(" × ")
      if whd_values.count > 0
        legend = []
        legend << "h" unless height.to_s == ""
        legend << "b" unless width.to_s == ""
        legend << "d" unless depth.to_s == ""
        rv = "#{rv} (#{legend.join("×")})"
      end
      rv = [rv, "⌀ #{dimension_to_s(diameter)}"].compact.join("; ") if dimension_to_s(diameter)
      return nil if rv.empty?
      rv
    end

    def numeric_value_with_fallback primary, secondary
      rv = primary ? primary : secondary
      rv if rv && (rv > 0)
    end

    def dimension_to_s value, nil_value = nil
      value ? number_with_precision(value, precision: 5, significant: true, strip_insignificant_zeros: true) : nil_value
    end
  end
end
