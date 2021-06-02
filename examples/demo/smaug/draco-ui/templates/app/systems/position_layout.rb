class PositionLayout < Draco::System
  filter LayoutGrid

  def tick(args)
    return if entities.nil?

    entities.each do |layout|

      current = world.scene || world

      parent = current.entities[layout.tree.parent_id].first
      #GTK::Log.puts_once layout.id, parent.inspect

      #next unless parent
      #next unless parent.components[:position]
      #next unless parent.components[:size]

      children = world.filter([Tree]).select { |e| e.tree.parent_id == layout.id }

      position(layout, parent, children)
    end

  end

  def position(layout, parent, children)
    attr = layout.layout_grid.space
    if attr == :evenly
      space_evenly(layout, parent, children)
    elsif attr == :start
      space_start(layout, parent, children)
    elsif attr == :end
      space_end(layout, parent, children)
    end
  end

  def space_start(layout, parent, children)
    y = parent_rect(parent).top

    y -= layout.layout_grid.padding

    children.each do |child|
      y -= child.size.height

      child.components << Position.new(
        x: align(layout, parent, child),
        y: y,
        absolute: true
      )
    end
  end

  def space_end(layout, parent, children)
    total_children_height = children.map { |c| c.size.height }.reduce { |p, c| p + c }
    y = parent_rect(parent).bottom + total_children_height

    y += layout.layout_grid.padding

    children.each do |child|
      y -= child.size.height

      child.components << Position.new(
        x: align(layout, parent, child),
        y: y,
        absolute: true
      )
    end
  end

  def space_evenly(layout, parent, children)

    total_children_height = children.map { |c| c.size.height }.reduce { |p, c| p + c }
    empty_space = parent_height(parent) - total_children_height
    space_per_child = empty_space / children.size

    y = parent_rect(parent).top

    children.each do |child|
      y -= space_per_child / 2
      y -= child.size.height

      child.components << Position.new(
        x: align(layout, parent, child),
        y: y,
        absolute: true
      )

      y -= space_per_child / 2
    end
  end

  def align(entity, parent, child)
    attr = entity.layout_grid.align
    padding = entity.layout_grid.padding
    return parent_rect(parent).left + padding if attr == :left
    return parent_rect(parent).right - padding - child.size.width if attr == :right

    parent_position(parent).x + parent_width(parent).half - child.size.width.half
  end

  def parent_position(parent)
    if parent
      parent.position
    else
      Position.new(x: 0, y: 0)
    end
  end

  def parent_width(parent)
    if parent
      parent.size.width
    else
      $gtk.args.grid.w
    end
  end

  def parent_height(parent)
    if parent
      parent.size.height
    else
      $gtk.args.grid.h
    end
  end

  def parent_rect(parent)
    if parent
      [
        parent_position(parent).x,
        parent_position(parent).y,
        parent.size.width,
        parent.size.height
      ]
    else
      $gtk.args.grid.rect
    end
  end

end
