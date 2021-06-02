class Position < Draco::Component
  attribute :x, default: 0
  attribute :y, default: 0

  attribute :dx, default: 0
  attribute :dy, default: 0

  attribute :absolute, default: false
end
