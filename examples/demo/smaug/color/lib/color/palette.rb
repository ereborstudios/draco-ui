module Color
  class Palette
    include Enumerable

    DEFAULT = Color::Palette.new(
      Pink: Color::RGB.from_hex('#FFC0CB'),
      Rackley: Color::RGB.from_hex('#5D8AA8'),
      Amber: Color::RGB.from_hex('#FFBF00'),
      Red: Color::RGB.from_hex('#FF0000'),
      Black: Color::RGB.from_hex('#000000'),
      White: Color::RGB.from_hex('#ffffff'),
    )

    attr_reader :colors

    def initialize(**colors)
      @colors = colors
    end

    def each(&block)
      return to_enum(__method__) unless block_given?
      (@colors || []).each(&block)
      self
    end

    def [](*names)
      colors = @colors.fetch_values(*names)
      colors.size == 1 ? colors.first : colors
    end

    def to_h
      @colors.dup
    end

    def names
      @colors.keys
    end

    def colors
      @colors.values
    end
  end

  Color::Palette::DEFAULT.each { |name, color| const_set name, color }
end
