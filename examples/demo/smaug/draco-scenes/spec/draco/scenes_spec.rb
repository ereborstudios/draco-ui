# frozen_string_literal: true

class TestComponent < Draco::Component
  attribute :tested, default: false
end

class TestEntity < Draco::Entity
  component TestComponent
end

class TestSystem < Draco::System
  filter TestComponent

  def tick(_args)
    entities.each { |entity| entity.test_component.tested = true }
  end
end

class Scene < Draco::World; end

class TestWorld < Draco::World
  include Draco::Scenes

  entity TestEntity

  scene :default do
    entity TestEntity

    systems TestSystem
  end

  scene :other, Scene
end

class TestWorldWithDefault < Draco::World
  include Draco::Scenes

  default_scene :other

  scene :default do
    entity TestEntity
  end

  scene :other, Scene
end

RSpec.describe Draco::Scenes do
  it "has a version number" do
    expect(Draco::Scenes::VERSION).not_to be nil
  end

  describe ".scene" do
    subject { TestWorld.new }

    it "has two scenes" do
      expect(subject.scenes.values.count).to eq(2)
    end
  end

  describe "#after_initialize" do
    context "with no default scene set" do
      subject { TestWorld.new }

      it "defaults to the first scene" do
        expect(subject.scene).to eq(subject.scenes[:default])
      end
    end

    context "with default scene set" do
      subject { TestWorldWithDefault.new }

      it "defaults to the first scene" do
        expect(subject.scene).to eq(subject.scenes[:other])
      end
    end
  end

  describe "#scene=" do
    subject { TestWorld.new }

    it "switches the scene" do
      subject.scene = :other

      expect(subject.scene).to eq(subject.scenes[:other])
    end
  end

  describe "#tick" do
    subject { TestWorld.new }
    let(:entities) { subject.filter(TestComponent).to_a + subject.scene.filter(TestComponent).to_a }

    it "runs systems on entities from the world and the scene" do
      subject.tick({})

      entities.each do |entity|
        expect(entity.test_component.tested).to be_truthy
      end
    end
  end
end
