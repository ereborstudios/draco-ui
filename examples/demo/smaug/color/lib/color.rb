require "smaug/color/lib/color/rgb.rb"
require "smaug/color/lib/color/hsl.rb"
require "smaug/color/lib/color/palette.rb"
require "smaug/color/lib/color/string.rb"
require "smaug/color/lib/color/hash.rb"

module Color

  class InvalidColorFormatError < ArgumentError
    def initialize(object)
      super("Invalid Format #{object.inspect}")
    end
  end

end
