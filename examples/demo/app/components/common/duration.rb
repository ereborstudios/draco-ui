class Duration < Draco::Component
  attribute :start, default: 0
  attribute :ticks, default: 60
  attribute :delete_entity, default: true
end
