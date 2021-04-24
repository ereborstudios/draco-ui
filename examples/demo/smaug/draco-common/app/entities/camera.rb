class Camera < Draco::Entity
  component Position
  component Draco::Tag(:default_camera)
  component Size, width: $gtk.args.grid.w, height: $gtk.args.grid.h

  def translate_pos(window_pos)
    {
      x: window_pos.x - position.x.to_i,
      y: window_pos.y - position.y.to_i
    }
  end
end
