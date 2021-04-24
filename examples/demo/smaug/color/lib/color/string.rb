module Color
  module String
    def to_color
      Color::RGB.from_hex(self)
    end
  end
end

class String
  include Color::String
end
