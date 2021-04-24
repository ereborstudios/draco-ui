module Draco
  module UI

    def self.included(mod)
      mod.extend(ClassMethods)
      mod.prepend(InstanceMethods)
    end

    module ClassMethods

      class EntityBuilder
        def self.component(component, opts = {})
          opts[:attributes] ||= []
          opts[:attributes].each do |name|
            define_method name do |v|
              @entity.components[component].send("#{name}=".to_sym, v)
            end
          end
        end

        def self.nested(entity_class_name, opts = {})
          define_method entity_class_name do |&block|
            klass = eval(Draco.camelize(entity_class_name.to_s))
            builder = opts[:builder] ? eval(Draco.camelize(opts[:builder].to_s)) : self.class
            @children << Docile.dsl_eval(builder.new(klass, @entity), &block)
          end
        end

        def initialize(klass = Draco::Entity, parent = nil)
          @entity = klass.new
          @entity.components << Tree.new(parent_id: (parent ? parent.id : nil))
          @entity.instance_variable_set :@parent, parent
          @entity.instance_eval do
            def parent
              @parent
            end
          end
          @children = []
        end

        def build(entities)
          entities.push(@entity)
          @children.each do |c|
            c.build(entities)
          end
          @entity
        end
      end

      class ButtonBuilder < EntityBuilder
        component :button_label, attributes: %w[text size padding]
        component :stateful_sprite, attributes: %w[variant]
        component :clickable, attributes: %w[on_click]
      end

      class LayoutBuilder < EntityBuilder
        component :layout_grid, attributes: %w[align orientation space padding]
        nested :layout
        nested :panel, builder: :panel_builder
        nested :button, builder: :button_builder
        nested :label, builder: :label_builder
      end

      class PanelBuilder < EntityBuilder
        component :size, attributes: %w[width height]
        nested :panel
        nested :layout, builder: :layout_builder
      end

      class LabelBuilder < EntityBuilder
        component :text, attributes: %w[text size padding font color]
      end

      def panel(&block)
        @default_panels ||= []
        Docile.dsl_eval(PanelBuilder.new(Panel), &block).build(@default_panels)
      end

      def layout(&block)
        @default_panels ||= []
        Docile.dsl_eval(LayoutBuilder.new(Layout), &block).build(@default_panels)
      end

    end

    module InstanceMethods
      def after_initialize
        super

        self.class.instance_variable_get(:@default_panels).each do |panel|
          #puts "Adding #{panel.inspect}"
          @entities.add(panel)
        end

        #@systems << RenderSprites
      end

      #def before_tick(context)
      #  puts "tick"
      #  super
      #end

    end
  end
end
