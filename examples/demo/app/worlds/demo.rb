class Demo < Draco::World
  include Draco::Events
  include Draco::Scenes
  include Draco::UI
  include Draco::Common::World

  systems RenderButtonLabels,
          RenderLabels,
          PositionAlignment,
          PositionLayout,
          MouseFocus,
          SpriteState,
          ChangeScene

  default_scene :scene1

  scene :scene1 do
    include Draco::UI

    layout {
      label {
        padding 0
        text 'draco ui'
        size 42
        color '#cca533ff'
        font 'fonts/kenney-fonts/blocks.ttf'
      }
      label {
        text <<-TEXT
        draco-ui is a quick and easy way to add overlay elements such as buttons and menus into your game.

        Design your UI using a simple declarative layout syntax and contribute back by adding new widgets to our growing library.
        TEXT
        size 4
        font 'fonts/kenney-fonts/pixel.ttf'
      }
      button {
        text 'Demo'
        size 12
        padding 18
        variant :yellow
        on_click ->(entity, world, args) {
          world.scene = :scene2
        }
      }
    }
  end

  scene :scene2 do
    include Draco::UI

    layout {
      align :left
      space :start
      button {
        text 'Top Left'
        variant :blue
      }
    }

    layout {
      align :left
      space :end
      button {
        text 'Bottom Left'
        variant :green
      }
    }

    layout {
      align :right
      space :start
      button {
        text 'Top Right'
        variant :grey
      }
    }

    layout {
      align :right
      space :end
      button {
        text 'Bottom Right'
        variant :red
      }
    }

    layout {
      align :center
      space :start
      button {
        text 'Top Center'
        variant :yellow
      }
    }

    layout {
      align :center
      space :end
      button { text 'Bottom Center' }
    }

    layout {
      align :center
      space :evenly

      label {
        text <<-TEXT
        Controls can be positioned automatically by grouping them in a layout and setting the alignment and justification options.

        Buttons are resized to fit their content.
        TEXT
        font 'fonts/kenney-fonts/pixel.ttf'
      }

      button {
        size 12
        padding 18
        on_click ->(entity, world, args) {
          world.scene = :scene3
        }
        text 'Continue'
        variant :green
      }
    }
  end

  scene :scene3 do
    include Draco::UI

    panel {
      width 600
      height 600


      layout {
        align :left
        space :start
        padding 32

        button {
          text 'Shrink'
          variant :red
          on_click ->(entity, world, args) {
            size = entity.parent.parent.size
            size.width -= 5
            size.height -= 5
          }
        }
      }

      layout {
        align :right
        space :start
        padding 32

        button {
          text 'Grow'
          variant :yellow
          on_click ->(entity, world, args) {
            size = entity.parent.parent.size
            size.width += 5
            size.height += 5
          }
        }
      }

      layout {
        align :center
        space :evenly
        padding 32

        label {
          text 'Panel'
          size 42
          font 'fonts/kenney-fonts/blocks.ttf'
        }

        label {
          text 'This is a panel'
          size 4
          padding 0
          font 'fonts/kenney-fonts/pixel.ttf'
        }

        button {
          text 'Continue'
          variant :green
          size 16
          padding 24
          on_click ->(entity, world, args) {
            world.scene = :scene4
          }
        }
      }
    }
  end

  scene :scene4 do
    include Draco::UI

    layout {
      align :center
      space :start

      panel {
        width $gtk.args.grid.w
        height 100

        layout {
          align :center
          space :evenly

          label {
            text 'Top Panel'
            size 12
            font 'fonts/kenney-fonts/pixel.ttf'
          }
        }
      }
    }

    layout {
      align :center
      space :evenly

      button {
        text 'Continue'
        variant :green
        size 16
        padding 24
        on_click ->(entity, world, args) {
          world.scene = :scene5
        }
      }
    }

    layout {
      align :center
      space :end

      panel {
        width $gtk.args.grid.w
        height 100

        layout {
          align :center
          space :evenly

          label {
            text 'Bottom Panel'
            size 12
            font 'fonts/kenney-fonts/pixel.ttf'
          }
        }
      }
    }
  end

  scene :scene5 do
    include Draco::UI

    panel {
      width $gtk.args.grid.w - 90
      height 400

      layout {
        align :center
        space :evenly

        label {
          text <<-TEXT
          Thanks for taking a look at draco-ui!

          There is a lot more work to be done.

          If you find it useful, please consider contributing additional widgets back to the project.
          TEXT
          color '#000000'.to_color
        }

        button {
          text 'Restart'
          variant :grey
          size 4
          on_click ->(entity, world, args) {
            world.scene = :scene1
          }
        }
      }

    }
  end
end
