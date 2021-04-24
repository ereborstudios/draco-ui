# Draco::State

This library provides a DSL to define state based entities in [Draco](https://github.com/guitsaru/draco).

## Usage

### Entities

This plugin allows you to specify a set of components where only one component can be active at a time. This allows
you to build state machine based systems or just to keep your entities from getting in unnatural states.

```ruby
class Guard < Draco::Entity
  include Draco::State

  state [Walking, Running, Jumping, Standing], default: Standing.new
end
```

If you don't define a default component, it will create an instance of the first component in the list. When you want to switch states, just add the new component:

```ruby
guard = Guard.new
guard.components << Walking.new

guard.state_changed.from
# => {class: "Standing"}

guard.state_changed.to
# => {class: "Walking"}

guard.state_changed.at
# => 2021-01-05 00:44:24.522127229 +0700
```

### Systems

Since the `Draco::StateChanged` component was added, we can write a system to deal with newly changed entities:

```ruby
class StateSystem < Draco::System
  filter Draco::StateChanged

  def tick(args)
    entity.components.add(Active)
    entity.components.delete(entity.state_changed)
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/draco-state. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/draco-state/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Draco::StateMachine project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/draco-state/blob/master/CODE_OF_CONDUCT.md).
