class SpriteEntity
  attr_sprite

  def initialize(entity, camera)
    if camera && !entity.position.absolute
      position = camera.translate_pos(entity.position)
    else
      position = entity.position
    end

    if entity.sprite.color
      rgba = entity.sprite.color.to_h
      @a = rgba[:a] # alpha
      @r = rgba[:r] # red saturation
      @g = rgba[:g] # green saturation
      @b = rgba[:b] # blue saturation
    end

    @source_w = entity.sprite.source_w if entity.sprite.source_w
    @source_h = entity.sprite.source_h if entity.sprite.source_h

    @source_x = entity.sprite.source_x if entity.sprite.source_x
    @source_y = entity.sprite.source_y if entity.sprite.source_y

    @x = position.x
    @y = position.y
    @w = entity.size.width
    @h = entity.size.height
    @path = entity.sprite.path
    @angle = entity.components[:rotation] ? entity.rotation.angle : 0
    @flip_vertically = entity.sprite.flip_vertically
    @flip_horizontally = entity.sprite.flip_horizontally
  end
end

class RenderSprites < Draco::System
  filter Position, Size, Sprite, Visible

  def tick(args)
    return if entities.nil?

    camera = world.respond_to?(:camera) ? world.camera : world.filter([Draco::Tag(:default_camera)]).first

    @sprites = entities.map do |entity|
      SpriteEntity.new(entity, camera)
    end

    args.outputs.sprites << @sprites
  end
end
