module Color
  module Hash
    def color(value)
      if value.kind_of? String
        self.merge! Color::RGB.from_hex(value).to_h
      elsif value.kind_of? RGB
        self.merge! value.to_h
      elsif value.kind_of? HSL
        self.merge! Color::RGB.from_hsl(*value).to_h
      else
        raise Color::InvalidColorFormatError, value
      end

      self
    end
  end
end

class Hash
  include Color::Hash
end
