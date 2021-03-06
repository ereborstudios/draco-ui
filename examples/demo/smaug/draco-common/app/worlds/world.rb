module Draco
  module Common
    module World

      def self.included(mod)
        mod.prepend(WorldPlugin)
      end

      module WorldPlugin

        def after_initialize
          super

          @systems << Animate
          @systems << RenderSprites
        end

      end

    end
  end
end
