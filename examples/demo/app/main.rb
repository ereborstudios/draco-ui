require 'smaug.rb'

def tick args
  args.outputs.background_color = '#000000'.to_color.lighten(0.1).to_ints
  args.state.world ||= Demo.new
  args.state.world.tick(args)
  args.state.world = nil if $gtk.files_reloaded.length > 0
end
