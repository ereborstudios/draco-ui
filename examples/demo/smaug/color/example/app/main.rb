require 'smaug.rb'

def swatch(x, y, color)
  $gtk.args.outputs.solids << {
    x:    x,
    y:    y,
    w:  100,
    h:  100
  }.color(color)
end

def msg(x, y, text)
  data = {
    x: x,
    y: y,
    text: text,
    size_enum: 0,
    alignment_enum: 0
  }.color('#ff00')
  $gtk.args.outputs.labels << data
end

def tick args
  ## Create colors

  # Create a color from RGB values (0-1.0)
  swatch 0, 0, Color::RGB.new(0.25, 0.25, 0.25)

  # Create a color from a hexadecimal string
  swatch 100, 0, Color::RGB.from_hex('#ff00')

  # Create a color from HSL values (0-1.0)
  swatch 0, 100, Color::HSL.new(0.25, 1.0, 0.25)

  ## Convert colors

  # String to color
  color = '#ff00'.to_color

  # Color to RGB hash
  args.outputs.debug << [20, 660, color.to_h.inspect, -2].label

  # Color to RGB array
  args.outputs.debug << [20, 640, color.to_ints.inspect, -2].label

  # Color to hexadecimal
  args.outputs.debug << [20, 620, "#{color.to_hex} (#{color.to_s})", -2].label

  ## Colorize outputs
  label = { x: 20, y: 600, text: 'Colorized output', size_enum: -2, alignment_enum: 0 }

  # From a color
  args.outputs.labels << label.color(Color::Amber)

  # From a string
  args.outputs.labels << label.merge({ y: 580 }).color('#ff00')

  ## Palettes

  # Create a palette of named colors
  @palette ||= Color::Palette.new(
    MyBlue: Color::RGB.from_hex('#5D8AA8')
  )
  swatch 200, 0, @palette[:MyBlue]

  # Palette::DEFAULT provides some common colors
  swatch 300, 0, Color::Palette::DEFAULT[:Pink]

  # Use color name constants for easy access to the default palette
  swatch 400, 0, Color::Amber

  # All color names from a palette
  names = Color::Palette::DEFAULT.names
  args.outputs.debug << [20, 700, 'Names: ' + names.join(', '), -2].label

  # All colors from a palette
  colors = Color::Palette::DEFAULT.colors
  args.outputs.debug << [20, 680, 'Colors: ' + colors.join(', '), -2].label

  # Iterate over each color in a palette
  i = 0
  Color::Palette::DEFAULT.each do |name, color|
    swatch i, 620, color
    i += 100
  end

  ## Adjust
  amount = (args.state.tick_count.idiv(5) % 100) * 0.01

  # Lighten
  args.outputs.debug << [20, 460, 'Lighten: ' + amount.to_s, -2].label
  swatch 0, 200, Color::Black.lighten(amount)

  # Darken
  args.outputs.debug << [20, 440, 'Darken: ' + amount.to_s, -2].label
  swatch 100, 200, Color::White.darken(amount)

  # Desaturate
  args.outputs.debug << [20, 420, 'Desaturate: ' + amount.to_s, -2].label
  swatch 200, 200, Color::Red.desaturate(amount)

  # Saturate
  args.outputs.debug << [20, 400, 'Saturate: ' + amount.to_s, -2].label
  swatch 300, 200, Color::HSL.new(1, 0, 0.5).saturate(amount)

  # Hue
  args.outputs.debug << [20, 380, 'Hue: ' + amount.to_s, -2].label
  swatch 400, 200, Color::Red.adjust_hue(amount)

  # Sum all components of two colors
  summed = Color::Amber + Color::Red
  swatch 0, 300, Color::Amber
  swatch 50, 300, summed
  swatch 100, 300, Color::Red
  swatch 150, 300, Color::Red + '#ffffff'

  # Subtract all components of two colors
  subtracted = Color::Pink - Color::Red
  swatch 200, 300, subtracted
end
