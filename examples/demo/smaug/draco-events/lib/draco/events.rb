module Draco
  # Public: A Draco plugin to add an event bus and observers to Draco worlds.
  module Events
    # Internal: An error that warns about an invalid Observer.
    class InvalidObserverError < StandardError
      def initialize
        super("An Observer must have a filter set")
      end
    end

    VERSION = "0.2.0"

    def self.included(mod)
      mod.extend(ClassAttributes)
      mod.prepend(WorldPlugin)
      mod.instance_variable_set(:@observers, [])
    end

    # Internal: The Events plugin for Draco Worlds.
    module WorldPlugin
      # Internal: The callback after the world is initialized
      #
      # Returns nothing.
      def after_initialize
        super
        @events = []
      end

      # Internal: The callback before #tick is called on the World.
      #
      # This method looks up the dispatched events and adds them to the list of
      # systems to run.
      #
      # context - The game engine's context for the current tick.
      #
      # Returns the systems to run on the tick.
      def before_tick(context)
        systems = super
        dispatch_table = Hash.new { |h, k| h[k] = [] }

        @events.each { |event| dispatch_table[event.system] += event.entities || []  }

        dispatched = dispatch_table.map do |system, entities|
          entities = entities.any? ? entities : filter(system.filter)

          system.new(entities: entities, world: self)
        end

        @events = []

        dispatched + systems
      end

      # Internal: The callback when a Component is added to an Event.
      #
      # entity - The Entity that a component was added to
      # component - The Component that was added to the entity
      #
      # Returns nothing.
      def component_added(entity, component)
        super

        observers
          .select { |observer| observer.match?(entity, component, :add) }
          .each { |observer| dispatch(observer.system, [entity]) }
      end

      # Internal: The callback when a Component is removed from an Event.
      #
      # entity - The Entity that a component was removed from
      # component - The Component that was removed from the entity
      #
      # Returns nothing.
      def component_removed(entity, component)
        super

        observers
          .select { |observer| observer.match?(entity, component, :remove) }
          .each { |observer| dispatch(observer.system, [entity]) }
      end

      # Public: Dispatches an event to be run on the next tick.
      #
      # system - The system to run
      # entities - The entities to pass to the system. If this is nil, the
      #            system's filter will check all of the world's entities
      #
      # Returns nothing.
      def dispatch(system, entities=nil)
        @events << Event.new(system: system, entities: entities)
      end

      # Internal: The list of observers added to the world.
      #
      # Returns an array of Observers.
      def observers
        self.class.instance_variable_get(:@observers) || []
      end
    end

    # Internal: An event to run on next tick.
    class Event
      # Internal: The System to run.
      attr_reader :system
      # Internal: The entities to pass to the System.
      attr_reader :entities

      def initialize(system:, entities: nil)
        @system = system
        @entities = Array(entities) if entities
      end
    end

    # Internal: An Observer checks when a component is added or removed from an
    # entity and dispatches an event if the component matches the observer.
    class Observer
      # Internal: The System to dispatch when the observer matches
      attr_reader :system

      # Internal: The Components to observe changes for. The observer matches if
      # the modified component is any of the components in this variable.
      attr_reader :components

      # Internal: The list of actions to match on. Supports `:add`, and `:remove`
      attr_reader :actions

      # Internal: Initializes an Observer.
      #
      # system - The system to run when the observer matches.
      # options - The Hash options to pass to the initializer (default: {}).
      #           :component - The component to observe (default: The system's filter).
      #           :on - The actions to observe (default: [:add, :remove]).
      def initialize(system, options = {})
        @actions = Array(options[:on] || [:add, :remove])
        @components = Array(options[:component] || system.filter)
        @system = system
      end

      # Internal: Says whether the current action matches the observer.
      #
      # entity - The Entity to match against the System's filter.
      # component - The Component that was added or removed from the Entity.
      # action - Either :add or :remove.
      #
      # Returns true or false.
      def match?(entity, component, action)
        actions.include?(action) &&
          components.include?(component.class) &&
          entity.components.map(&:class) & system.filter == system.filter
      end
    end

    # Internal: Adds the observe DSL to the World class.
    module ClassAttributes
      # Public: Adds an observer to the World.
      #
      # system - The system to run when the observer matches.
      # options - The Hash options to pass to the initializer (default: {}).
      #           :component - The component to observe (default: The system's filter).
      #           :on - The actions to observe (default: [:add, :remove]).
      #
      # Returns nothing.
      def observe(system, options = {})
        raise Draco::Events::InvalidObserverError if system.filter.empty?

        @observers << Observer.new(system, options)
      end
    end
  end
end
