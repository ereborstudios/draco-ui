class ChangeScene < Draco::System

  def tick(args)
    if args.inputs.keyboard.key_down.one
      world.scene = :scene1
    end

    if args.inputs.keyboard.key_down.two
      world.scene = :scene2
    end

    if args.inputs.keyboard.key_down.three
      world.scene = :scene3
    end

    if args.inputs.keyboard.key_down.four
      world.scene = :scene4
    end

    if args.inputs.keyboard.key_down.five
      world.scene = :scene5
    end

    if args.inputs.keyboard.key_down.six
      world.scene = :scene6
    end
  end

end
