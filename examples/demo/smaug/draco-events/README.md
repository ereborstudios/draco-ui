# Draco::Events

This library provides an event bus and observer functionality for [Draco](https://github.com/guitsaru/draco).

## Usage

### Worlds

```ruby
class World < Draco::World
  include Draco::Events

  observe CleanupDestroyed
  observe GameOverScreen, component: Dead, on: :add
  observe PlayMusic, component: Mute, on: :remove
end

world = World.new

world.dispatch(ShowMenu)
world.dispatch(SellUnit, [unit_one, unit_two])
```

### Dispatch

Dispatch allows you to run a System on demand rather than on every tick. These will run at the beginning of the next click.

There are two ways to dispatch an event:

* `world.dispatch(System)` will run the system using the System's filter on all the entities in the world.
* `world.dispatch(System, entities)` will run the system on the entities you gave it.

### Observers

Observers let you automatically dispatch an event any time a component is added or removed.

* `observe System` will run `System` every time a component is added that causes the entity to match the system's filter.
* `observe System, component: AnotherComponent` will run `System` every time `AnotherComponent` is added or removed and the entity matches the system's filter.
* `observe System, component: AnotherComponent, on: :add` will run `System` every time `AnotherComponent` is added and the entity matches the system's filter.
* `observe System, component: AnotherComponent, on: :remove` will run `System` every time `AnotherComponent` is removed and the entity matches the system's filter.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'draco-events'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install draco-events

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/draco-events. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/draco-events/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Draco::Events project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/draco-events/blob/master/CODE_OF_CONDUCT.md).
