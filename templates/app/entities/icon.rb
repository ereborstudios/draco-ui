class Icon < Draco::Entity
  component Size, width: 32, height: 32
  component Visible

  component Sprite

  component Clickable

  component Tag(:ready)
  Tag(:focused)
  Tag(:active)
end
