class EntityDuration < Draco::System
  filter Duration

  def tick(args)
    current_tick = args.state.tick_count
    entities.each do |entity|
      next unless entity.components[:duration]

      if current_tick > entity.duration.start + entity.duration.ticks
        if entity.duration.delete_entity
          entity.components.delete(entity.components[:duration])
          world.scene.entities.delete(entity) if world.scene
          world.entities.delete(entity)
        else
          entity.components.delete(entity.components[:duration])
        end
      end
    end
  end
end
