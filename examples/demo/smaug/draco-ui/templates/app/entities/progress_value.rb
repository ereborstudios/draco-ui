class ProgressValue < Draco::Entity
  component Position
  component Size
  component Sprite,
            path: 'sprites/draco-ui/progress/background_03.png',
            source_x: 0,
            source_y: 0,
            source_w: 400,
            source_h: 41
end
