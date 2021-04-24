class RenderSprites < Draco::System
  filter Position, Size, Sprite, Visible

  def tick(args)
    return if entities.nil?

    camera = world.respond_to?(:camera) ? world.camera : world.filter([Draco::Tag(:default_camera)]).first

    sprites = entities.map do |entity|
      if camera
        position = camera.translate_pos(entity.position)
      else
        position = entity.position
      end
      {
        x: position.x,
        y: position.y,
        w: entity.size.width,
        h: entity.size.height,
        path: entity.sprite.path,
        angle: entity.components[:rotation] ? entity.rotation.angle : 0,
        flip_vertically: entity.sprite.flip_vertically,
        flip_horizontally: entity.sprite.flip_horizontally,
      }
    end

    args.outputs.sprites << sprites
  end
end
