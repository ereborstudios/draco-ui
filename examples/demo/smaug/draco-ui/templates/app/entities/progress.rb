class Progress < Draco::Entity
  component Visible
  component Position, x: 355, y: 64, absolute: true
  component Size, width: 400, height: 42
  component Speed, speed: 1
  component Sprite,
            path: 'sprites/draco-ui/progress/background_01.png',
            source_x: 0,
            source_y: 0,
            source_w: 400,
            source_h: 41
  component DisplayProgress
end
