module Color
  class HSL
    attr_reader :hue, :saturation, :lightness, :alpha

    class << self

      def convert(color)
        case color
        when Color::HSL then color
        when Color::RGB
          rgb = color.rgb
          r, g, b = rgb

          min = rgb.min
          max = rgb.max
          chroma = max - min
          sum = max + min
          l = sum / 2.0

          return new(0, 0, l, color.alpha) if chroma == 0.0

          s = l > 0.5 ? chroma / (2.0 - sum) : chroma / sum

          h = case max
              when r then ((g - b) / chroma) / 6 + (g < b && 1 || 0)
              when g then ((b - r) / chroma) / 6.0 + (1.0 / 3.0)
              when b then ((r - g) / chroma) / 6.0 + (2.0 / 3.0)
              end
          new(h, s, l, color.alpha)
        else
          raise Color::InvalidColorFormatError, color
        end
      end

    end

    def initialize(hue, saturation, lightness, alpha = 1.0)
      @hue, @saturation, @lightness, @alpha = hue % 1.0, saturation.to_f, lightness.to_f, alpha.to_f
    end

    def to_a
      [@hue, @saturation, @lightness, @alpha]
    end

    def to_hex
      Color::RGB.convert(self).to_hex
    end

    def lighten(amount)
      @lightness = (@lightness + amount).lesser(1.0)
      self
    end

    def darken(amount)
      @lightness = (@lightness - amount).greater(0)
      self
    end

    def desaturate(amount)
      @saturation = (@saturation - amount).greater(0)
      self
    end

    def saturate(amount)
      @saturation = (@saturation + amount).lesser(1.0)
      self
    end

    def adjust_hue(amount)
      @hue = (@hue + amount).lesser(1.0)
      self
    end
  end
end
