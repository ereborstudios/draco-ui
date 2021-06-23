class Banner < Draco::Entity
  component Size, width: 520, height: 120
  component Rotation, angle: 0
  component Sprite,
            path: 'sprites/kenney-ui-pack/red_panel.png',
            color: '#ffffff'.to_color
  component Centered
  component Visible
  component Duration, ticks: 30

  def self.notify(ticks = 30, extra = [], &block)
    entities = []
    Docile.dsl_eval(Draco::UI::ClassMethods::BannerBuilder.new(Banner), &block).build(entities)
    entities.each do |e|
      e.components << Duration.new(
        start: $gtk.args.tick_count,
        ticks: ticks
      )
      extra.each { |c| e.components << c.new }
    end

    $gtk.args.state.world.entities << entities
  end
end
