class Clickable < Draco::Component
  attribute :on_click, default: ->(entity, world, args) {
    puts "Clicked #{entity.class} (#{entity.id})"
  }
end
