# Draco::Scenes

This library provides a way to define multiple scenes within a world for the [Draco](https://github.com/guitsaru/draco) ECS library.

## Usage

```ruby
class Inventory < Draco::World
  entity Backpack

  systems RenderInventory,
          HandleInventoryInput
end

class World < Draco::World
  include Draco::Scenes

  entity Player

  systems Render

  default_scene :overworld

  scene :overworld do
    entity Map
    entity Camera

    systems HandleMovementInput
  end

  scene :pause do
    entity ResumeButton
    entity QuitButton

    systems HandleMenuInput
  end

  scene :inventory, Inventory
end

world = World.new
world.scene = :pause
```

A scene can either be defined inline by using a block or can be defined as a `Draco::World` in another class. When the `#tick` method is run on the world, it runs the systems for the current scene and itself on the combined entities of the scene and the world.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/draco-scenes. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/draco-scenes/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Draco::Scenes project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/draco-scenes/blob/master/CODE_OF_CONDUCT.md).
