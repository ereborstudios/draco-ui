class RenderLabels < Draco::System
  filter Text, Position, Visible

  def tick(args)
    return if entities.nil?

    labels = entities.map do |entity|
      text = entity.text.text
      size = entity.text.size
      padding = entity.text.padding
      font = entity.text.font
      color = entity.text.color

      split = args.string.wrapped_lines text, 65

      y = (entity.position.y + (entity.size.height - padding))

      split.map_with_index do |s, i|
        result = {
          x: entity.position.x,
          y: y,
          text: s.tr("\n", ''),
          font: font,
          size_enum: size,
          alignment_enum: 1
        }.color(color)
        y -= 28
        result
      end
    end.flatten

    args.outputs.labels << labels
  end
end
