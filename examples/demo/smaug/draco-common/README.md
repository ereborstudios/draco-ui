# Draco::Common

This package adds some common components and systems to your Draco project to help you get started.

## Features

### Components

* Animated
* BelongsTo
* Position
* Rotation
* Size
* Speed
* Sprite
* Visible

### Systems

* Animate
* RenderSprites

## Installation

In the `Smaug.toml` file of your project, add...

```toml
[dependencies]
draco = "https://github.com/guitsaru/draco.git"    # (draco is required)
draco-common = "..."
```

Then run `smaug install`.


## Example

```ruby
class Player < Draco::Entity

  component Position,
    x: $gtk.args.grid.center_x - 50,
    y: $gtk.args.grid.center_y - 40,
    # dx: 0,
    # dy: 0

  component Rotation, angle: 0

  component Size, width: 100, height: 80

  component Speed, speed: 8, acceleration: 2, deceleration: 0.5

  component Sprite,
    path: 'sprites/dragon-0.png',
    # flip_vertically: false,
    # flip_horizontally: false,

  component Visible

  component Animated, frames: [
    { frames: 5, path: 'sprites/dragon-0.png' },
    { frames: 5, path: 'sprites/dragon-1.png' },
    { frames: 5, path: 'sprites/dragon-2.png' },
    { frames: 5, path: 'sprites/dragon-3.png' },
    { frames: 5, path: 'sprites/dragon-4.png' },
    { frames: 5, path: 'sprites/dragon-5.png' },
  ]

  component BelongsTo, id: 1
end

class HelloWorld < Draco::World
  include Draco::Common::World

  entity Player, as: :player
end
```
