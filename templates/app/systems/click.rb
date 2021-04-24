class Click < Draco::System
  filter Clickable

  def tick(args)
    entities.each do |entity|
      entity.clickable.on_click.call(entity, world, args)
    end
  end

end
