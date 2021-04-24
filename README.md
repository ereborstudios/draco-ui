# Draco::UI

> draco-ui is a quick and easy way to add overlay elements such as buttons and menus into your game.

Design your UI using a simple declarative layout syntax and contribute back by adding new widgets to our growing library.

---

## Installation

If you don't already have a game project, run `smaug new` to create one.

### Add dependencies

```bash
$ smaug add draco
$ smaug add draco-common
$ smaug add draco-state
$ smaug add draco-events
$ smaug add color
$ smaug add kenney-ui-pack
$ smaug add kenney-fonts
```

### Install

```bash
$ smaug add draco-ui
$ smaug install
```

```ruby
# app/main.rb
require 'smaug.rb'

def tick args
  args.state.world ||= HelloWorld.new
  args.state.world.tick(args)
end
```

Next, create a World and include `Draco::UI`.

```ruby
# app/worlds/hello_world.rb
class HelloWorld < Draco::World
  include Draco::UI
end
```

Start the game with `smaug run`, and your UI should appear.

---

### Layout

Wrap entities in a Layout to automatically position them relative to each other and the parent or grid.

| Attribute   | Default   | Valid                  | Note                                                                                                                                                   |
|-------------|-----------|------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------|
| align       | :center   | :center, :left, :right | Sets the horizontal position of all entities inside the layout relative to the parent. If the layout has no parent, alignment is relative to the grid. |
| space       | :evenly   | :evenly, :start, :end  | Distribute entities evenly spaced over the height of the parent (or grid), or push them to the top or bottom.                                          |
| padding     | 0         | Integer                | Set a distance from all edges of the parent for entities nested inside of the layout to be placed                                                      |
| orientation | :vertical | :vertical              | _Not implemented_                                                                                                                                      |

#### Example


```ruby
layout {
  align :center
  space :evenly
  padding 24
  orientation :vertical

  # Nested entities...
  button { text 'Button 1' }
  button { text 'Button 2' }
}
```

### Label

Display single or multiple lines of text content.

| Attribute | Default            | Valid                            | Note                                                                                                                                                                               |
|-----------|--------------------|----------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| text      | nil                | String                           | Text will be line-wrapped at 65 characters                                                                                                                                         |
| size      | 0                  | Integer                          | Value given to `args.outputs.labels` (**SIZE_ENUM**). 0 represents "default size". A negative value will decrease the label size. A positive value will increase the label's size. |
| padding   | 0                  | Integer                          | Add space to all sides of the label                                                                                                                                                |
| font      | Subject to change  | Relative path to a TrueType font | _Not implemented_                                                                                                                                                                  |
| color     | '#ffffff'.to_color | Color                            | Color may be expressed in any format understood by https://smaug.dev/packages/color/                                                                                               |

#### Example


```ruby
# Headline
label {
  padding 0
  text 'Hello World'
  size 42
  color '#cca533ff'
  font 'fonts/Fonts/Kenney Blocks.ttf'
}

# Paragraph
label {
  text <<-TEXT
  Lorem ipsum dolor sit amet, consectetur adipiscing elit.
  Aliquam eget dolor venenatis, fermentum enim quis, faucibus enim.
  Vivamus elementum mattis ornare.
  TEXT
  size 4
  font 'fonts/Fonts/Kenney Pixel.ttf'
}
```

### Panel

Create a panel to display a visual container for your content.

| Attribute | Default | Valid   | Note                        |
|-----------|---------|---------|-----------------------------|
| width     | 100     | Integer | Set the width of the panel  |
| height    | 100     | Integer | Set the height of the panel |

#### Example

```ruby
panel {
  width $gtk.args.grid.w
  height 400
  layout {
    label {
      text 'Example Panel'
    }
  }
}
```

### Button

A clickable, customizable all-purpose button control.

| Attribute | Default | Valid            | Note                                                       |
|-----------|---------|------------------|------------------------------------------------------------|
| text      | 100     | Integer          | Button label                                               |
| size      | 0       | Integer          | __SIZE_ENUM__                                              |
| padding   | 12      | Integer          | Space between the content and the edges of the button      |
| variant   | 'blue'  | String or Symbol | Any value supported by your `StatefulSprite :dynamic_path` |
| on_click  |         | Proc             | `->(entity, world, args) { #... }`                         |

#### Example

```ruby
button {
  text 'Confirm'
  variant :green
  size 16
  padding 24
  on_click ->(entity, world, args) {
    # ...Anything you want!
  }
}
```
