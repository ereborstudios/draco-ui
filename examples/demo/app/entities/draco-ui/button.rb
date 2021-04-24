class Button < Draco::Entity
  component Size, width: 190, height: 49
  component Visible
  component ButtonLabel

  component StatefulSprite

  component Clickable

  component Tag(:ready)
  Tag(:focused)
  Tag(:active)
end
