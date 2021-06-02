class Sprite < Draco::Component
  attribute :path
  attribute :flip_vertically, default: false
  attribute :flip_horizontally, default: false
  attribute :color, default: nil
  attribute :source_w
  attribute :source_h
  attribute :source_x
  attribute :source_y
end
