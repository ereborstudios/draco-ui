class StatefulSprite < Draco::Component
  attribute :ready
  attribute :focused
  attribute :active

  attribute :variants, default: %w{blue green grey red yellow}
  attribute :variant, default: 'blue'
  attribute :states, default: { ready: '00', focused: '02', active: '01' }

  attribute :dynamic_path, default: ->(entity, world, args) {
    variant = entity.stateful_sprite.variant
    states = entity.stateful_sprite.states

    state = states[:ready] if entity.components[:ready]
    state = states[:focused] if entity.components[:focused]
    state = states[:active] if entity.components[:active]

    "sprites/kenney-ui-pack/#{variant}_button#{state}.png"
  }
end
