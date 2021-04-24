# frozen_string_literal: true

module Draco
  # Public: A plugin to enable scene defintions for a Draco::World.
  module Scenes
    # Internal: An error for when a scene definition was given both a block and a class.
    class MultipleSceneDefinitionsError < StandardError
      def initialize
        super("A scene can be defined as a class or a block, but not both.")
      end
    end

    # Internal: An error saying the desired scene was not defined.
    class UndefinedSceneError < StandardError; end

    VERSION = "0.2.0"

    def self.included(mod)
      mod.extend(ClassMethods)
      mod.prepend(InstanceMethods)
      mod.instance_variable_set(:@scene_definitions, {})
      mod.instance_variable_set(:@default_scene, nil)
    end

    # Internal: The plugin code for a Draco::World
    module InstanceMethods
      def after_initialize
        @scenes = {}

        scene_definitions.each do |name, klass|
          @scenes[name] = klass.new
        end

        @current_scene = default_scene
      end

      def before_tick(context)
        super + @current_scene.systems.map do |system|
          entities = filter(system.filter)

          system.new(entities: entities, world: self)
        end
      end

      def filter(*components)
        super.merge(@current_scene.filter(*components))
      end

      def scenes
        @scenes
      end

      def scene
        @current_scene
      end

      def scene=(name)
        raise UndefinedSceneError, "No scene defined with name #{name.inspect}" unless @scenes[name]

        @current_scene = @scenes[name]
      end

      def default_scene
        defined = self.class.instance_variable_get(:@default_scene)
        raise UndefinedSceneError, "No scene defined with name #{defined.inspect}" unless @scenes[defined]

        @scenes[defined]
      end

      def scene_definitions
        self.class.instance_variable_get(:@scene_definitions) || {}
      end
    end

    # Internal: The class methods defining the scene DSL
    module ClassMethods
      def scene(name, maybe_class = nil, &block)
        raise Draco::Scenes::MultipleSceneDefinitionsError if maybe_class && block

        @default_scene ||= name
        @scene_definitions[name] = maybe_class || Class.new(Draco::World, &block)
      end

      def default_scene(name)
        @default_scene = name
      end
    end
  end
end
