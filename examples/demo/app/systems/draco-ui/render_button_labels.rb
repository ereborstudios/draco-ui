class RenderButtonLabels < Draco::System
  filter ButtonLabel, Position, Visible

  def tick(args)
    return if entities.nil?

    button_labels = entities.map do |entity|
      text = entity.button_label.text
      size = entity.button_label.size
      padding = entity.button_label.padding
      font = 'fonts/kenney-ui-pack/kenvector_future.ttf'

      # Set the button size to contain the text
      w, h = args.gtk.calcstringbox(text, size, font)
      entity.components << Size.new(width: w + (padding * 2), height: h + (padding * 2))

      {
        x: entity.position.x + padding,
        y: (entity.position.y + (entity.size.height - padding)),
        text: text,
        font: font,
        size_enum: size
      }
    end

    args.outputs.labels << button_labels
  end
end
