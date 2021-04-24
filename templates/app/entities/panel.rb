class Panel < Draco::Entity
  component Centered
  component Size, width: 100, height: 100
  component Sprite, path: 'sprites/kenney-ui-pack/blue_panel.png'
  component Visible
end
