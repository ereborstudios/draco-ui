class UpdateProgress < Draco::System
  filter DisplayProgress, Visible

  def tick(args)
    entities.each do |entity|
      new_value = entity.display_progress.value.call
      entity.display_progress._value = new_value

      progress_value = get_progress_value(entity)
      multiplier = entity.size.width.idiv(entity.display_progress.max)
      progress_value.position.x = entity.position.x
      progress_value.position.y = entity.position.y
      progress_value.size.height = entity.size.height
      target_width = (entity.display_progress._value * multiplier).greater(0)

      if progress_value.size.width > target_width
        progress_value.size.width -= entity.speed.speed
      elsif progress_value.size.width < target_width
        progress_value.size.width += entity.speed.speed
      end

      args.outputs.sprites << {
        x: entity.position.x,
        y: entity.position.y,
        w: entity.size.width,
        h: entity.size.height,
        path: entity.display_progress.background,
        source_x: 0,
        source_y: 0,
        source_w: 400,
        source_h: 41
      }

      args.outputs.sprites << SpriteEntity.new(progress_value, nil)
    end
  end

  def get_progress_value(entity)
    progress_value_id = entity.display_progress.progress_value_id
    progress_value = world.entities[progress_value_id].first

    unless progress_value
      progress_value = ProgressValue.new({
        sprite: {
          path: entity.display_progress.fill
        }
      })
      world.entities << progress_value
      entity.display_progress.progress_value_id = progress_value.id
    end

    progress_value
  end

end
