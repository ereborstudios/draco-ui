module Draco
  module State
    VERSION = "0.2.0"

    class InvalidDefaultError < StandardError; end
    class NoStatesDefinedError < StandardError; end
    class NotAnEntityError < StandardError; end
    class StateExistsError < StandardError; end
    class StateNotSetError < StandardError; end

    def self.included(mod)
      raise NotAnEntityError, "Draco::State can only be included on Draco::Entity subclasses." unless mod.ancestors.include?(Draco::Entity)

      mod.extend(ClassMethods)
      mod.prepend(EntityPlugin)
    end

    module ClassMethods
      def state(values, options = {})
        raise Draco::State::StateExistsError, "This entity already has a state defined" if @default_state
        raise Draco::State::NoStatesDefinedError, "This entity has no possible states defined." if values.nil? || values.empty?

        @default_state = options.delete(:default) || values.first.new
        @state_options = values
        unless values.include?(@default_state.class)
          message = ["The default state is not a member of the possible states."]
          messate += "Make sure you initialize the class." if @default_state.is_a?(Class)

          raise Draco::State::InvalidDefaultError, message.join(" ")
        end
      end
    end

    module EntityPlugin
      def after_initialize
        super
        components.add(self.class.instance_variable_get(:@default_state))
      end

      def before_component_added(component)
        component = super || component
        options = self.class.instance_variable_get(:@state_options)
        return component unless options.include?(component.class)

        from = previous_state
        if !has_state_change?(component) && from
          state_change = Draco::StateChanged.new(from: from, to: component, at: Time.now)

          components.add(state_change)
        end

        component
      end

      def after_component_added(component)
        component = super || component
        options = self.class.instance_variable_get(:@state_options)

        return component unless options.include?(component.class)
        state_change = state_change_component
        components.delete(state_change.from) if state_change
      end

      def before_component_removed(component)
        component = super || component
        options = self.class.instance_variable_get(:@state_options)

        return component unless options.include?(component.class)
        state_change = state_change_component
        raise Draco::State::StateNotSetError, "removing #{component.inspect} would leave this entity in an invalid state" unless state_change && state_change.from == component
      end

      private
      def state_change_component
        state_change_name = Draco.underscore(Draco::StateChanged.name.to_s).to_sym
        components[state_change_name]
      end

      def has_state_change?(component)
        return false unless state_change_component
        return state_change_component.to == component
      end

      def previous_state
        name =
          self.class.instance_variable_get(:@state_options)
          .map { |state| Draco.underscore(state.name.to_s).to_sym }
          .find { |name| components[name] }

        components[name] if name
      end
    end
  end

  class StateChanged < Draco::Component
    attribute :from
    attribute :to
    attribute :at
  end
end
