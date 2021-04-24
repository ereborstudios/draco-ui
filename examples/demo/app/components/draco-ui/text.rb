class Text < Draco::Component
  attribute :text
  attribute :size, default: 0
  attribute :padding, default: 0
  attribute :font, default: 'fonts/kenney-ui-pack/kenvector_future.ttf'
  attribute :color, default: '#ffffff'.to_color
end
