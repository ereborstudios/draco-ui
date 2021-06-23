class SlideEffect < Draco::System
  filter Visible, Position, Duration, Slide

  def tick(args)
    entities.each do |entity|
      entity.components.delete(entity.components[:centered]) if entity.components[:centered]

      next unless entity.components[:duration]

      elapsed_time = entity.duration.start.elapsed_time
      direction = entity.slide.direction

      if direction == :up
        entity.position.y += elapsed_time
      elsif direction == :down
        entity.position.y -= elapsed_time
      elsif direction == :left
        entity.position.x -= elapsed_time
      else
        entity.position.x += elapsed_time
      end
    end
  end
end
