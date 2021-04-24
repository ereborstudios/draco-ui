module Color
  class RGB
    attr_reader :red, :green, :blue, :alpha

    class << self

      def suppress(color)
        return color.map { |c| c / color.max } unless color.max.between?(0.0, 1.0)
        color
      end

      def convert(color)
        case color
        when Color::RGB then color
        when Color::HSL then from_hsl(*color)
        when String then from_hex(color)
        else
          raise Color::InvalidColorFormatError, color
        end
      end

      def from_hex(str)
        str = str[1..str.length] if str[0] == '#'
        red = str[0..1].hex.to_i(16) / 255.0
        green = str[2..3].hex.to_i(16) / 255.0
        blue = str[4..5].hex.to_i(16) / 255.0
        new(red, green, blue)
      end

      def from_hsl(hue, saturation, lightness, alpha = 1.0)
        m2 = if lightness <= 0.5
               lightness * (saturation + 1)
             else
               lightness + saturation - lightness * saturation
             end

        m1 = lightness * 2 - m2

        color = [
          hue_to_rgb(m1, m2, hue + 1.0 / 3),
          hue_to_rgb(m1, m2, hue),
          hue_to_rgb(m1, m2, hue - 1.0 / 3)
        ]
        color << alpha
        new(*color.map { |c| c.round(2) })
      end

      private

      # helper for making rgb
      def hue_to_rgb(m1, m2, h)
        h += 1 if h < 0
        h -= 1 if h > 1
        return m1 + (m2 - m1) * h * 6 if h * 6 < 1
        return m2 if h * 2 < 1
        return m1 + (m2 - m1) * (2.0/3 - h) * 6 if h * 3 < 2
        return m1
      end

    end

    def initialize(red, green, blue, alpha = 1.0)
      @red, @green, @blue, @alpha = red.to_f, green.to_f, blue.to_f, alpha.to_f
    end

    def +(color)
      color = Color::RGB.convert(color)
      color = [
        @red + color.red,
        @green + color.green,
        @blue + color.blue
      ]
      self.class.new(*self.class.suppress(color), @alpha)
    end

    def -(color)
      color = Color::RGB.convert(color)
      self.class.new(*self.class.suppress([
        @red - color.red,
        @green - color.green,
        @blue - color.blue
      ].map { |c| c >= 0 ? c : 0 }), @alpha)
    end

    def to_h
      red, green, blue, alpha = to_ints(with_alpha: true)
      { r: red, g: green, b: blue, a: alpha }
    end

    def to_a(with_alpha: true)
      with_alpha ? [@red, @green, @blue, @alpha] : [@red, @green, @blue]
    end

    def rgb
      to_a(with_alpha: false)
    end

    def to_ints(with_alpha: true)
      to_a(with_alpha: with_alpha).map { |v| (v * 255).to_i(16) }
    end

    def to_hex(with_alpha: true)
      to_ints(with_alpha: with_alpha).map { |v| "%02x" % v }.join
    end

    def to_s
      "##{to_hex}"
    end

    def lighten(amount)
      hsl = Color::HSL.convert(self).lighten(amount)
      Color::RGB.from_hsl(*hsl)
    end

    def darken(amount)
      hsl = Color::HSL.convert(self).darken(amount)
      Color::RGB.from_hsl(*hsl)
    end

    def desaturate(amount)
      hsl = Color::HSL.convert(self).desaturate(amount)
      Color::RGB.from_hsl(*hsl)
    end

    def saturate(amount)
      hsl = Color::HSL.convert(self).saturate(amount)
      Color::RGB.from_hsl(*hsl)
    end

    def adjust_hue(amount)
      hsl = Color::HSL.convert(self).adjust_hue(amount)
      Color::RGB.from_hsl(*hsl)
    end
  end
end
