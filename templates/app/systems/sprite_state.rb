class SpriteState < Draco::System
  filter StatefulSprite

  def tick(args)
    entities.each do |entity|
      entity.components << Sprite.new(
        path: entity.stateful_sprite.dynamic_path.call(entity, world, args)
      )
    end
  end
end
