class PositionAlignment < Draco::System
  filter Centered, Size

  def tick(args)
    return if entities.nil?

    entities.each do |entity|
      entity.components << Position.new(
        x: (args.grid.w / 2 - (entity.size.width / 2)),
        y: (args.grid.h / 2 - (entity.size.height / 2)),
        absolute: true
      )
    end
  end
end
