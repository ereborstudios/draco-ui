class MouseFocus < Draco::System
  filter Clickable, Position

  def tick(args)
    return if entities.nil?

    current = world.scene || world

    current.filter([Clickable, Position]).each do |entity|
      if args.inputs.mouse.point.inside_rect?(entity_rect(entity))
        unless entity.components[:focused]
          entity.components << Focused.new
          world.dispatch(Focus, entity)
        end
        if args.inputs.mouse.button_left
          unless entity.components[:active]
            entity.components << Active.new
          end
          entity.position.y -= 4
        else
          entity.components.delete(entity.active) if entity.components[:active]
          world.dispatch(Click, entity) if args.inputs.mouse.up
        end
      else
        entity.components << Ready.new unless entity.components[:ready]
        entity.components.delete(entity.focused) if entity.components[:focused]
        entity.components.delete(entity.active) if entity.components[:active]
      end
    end
  end

  def entity_rect(e)
    [e.position.x, e.position.y, e.size.width, e.size.height]
  end
end
