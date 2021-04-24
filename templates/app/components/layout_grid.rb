class LayoutGrid < Draco::Component
  attribute :orientation, default: :vertical
  attribute :space, default: :evenly
  attribute :align, default: :center
  attribute :padding, default: 0
end
