class Focus < Draco::System
  filter ButtonLabel, Focused

  def tick(args)
    puts "Focused"
  end

end
