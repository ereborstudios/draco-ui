# color

> Color manipulation utilities for DragonRuby

## Usage

### Create colors

There are several ways to create a color.

```ruby
Color::RGB.new(0.25, 0.25, 0.25) # from RGB values
Color::HSL.new(0.25, 1.0, 0.25) # from HSL values
Color::RGB.from_hex('#ff00') # from a hexadecimal string
```
---

### Convert colors

```ruby
color = '#ff00'.to_color # String to color
color.to_h # Color to RGB hash
color.to_ints # Color to RGB array
color.to_hex # Color to hexadecimal
```

---

### Colorize outputs

```ruby
label = { x: 20, y: 600, text: 'Colorized output', size_enum: -2, alignment_enum: 0 }
args.outputs.labels << label.color(Color::Amber) # From a color
args.outputs.labels << label.merge({ y: 580 }).color('#ff00') # From a string
```

---

### Manipulate colors

Darken or lighten a color

```ruby
Color::Black.lighten(amount)
Color::White.darken(amount)
```

Saturate or desaturate a color

```ruby
Color::HSL.new(1, 0, 0.5).saturate(amount)
Color::Red.desaturate(amount)
```

Adjust the hue of a color

```ruby
Color::Red.adjust_hue(amount)
```

Sum or subtract all components of two colors

```ruby
foo = Color::Amber + Color::Red
bar = Color::Pink - Color::Red
```

---

### Palettes

The default palette provides some convenient colors as named constants.

```ruby
Color::Palette::DEFAULT
Color::Palette::DEFAULT[:AirForceBlue]
Color::AirForceBlue
```

Create your own palette of named colors

```ruby
palette = Color::Palette.new(
  MyBlue: Color::RGB.from_hex('#5D8AA8')
)

palette[:MyBlue]
```

Some more examples...

```ruby
# All color names from a palette
names = Color::Palette::DEFAULT.names

# All colors from a palette
colors = Color::Palette::DEFAULT.colors

# Iterate over each color in a palette
Color::Palette::DEFAULT.each { |name, color| # ... }
```

## Inspired by

* [chroma](https://github.com/jfairbank/chroma)
* [rgb](https://github.com/plashchynski/rgb)
* [pigment](https://github.com/P3t3rU5/pigment)
