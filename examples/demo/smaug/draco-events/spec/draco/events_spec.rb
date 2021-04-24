class TestComponent < Draco::Component
  attribute :tested, default: false
end

class AddedComponent < Draco::Component; end
class RemovedComponent < Draco::Component; end

class DispatchedSystem < Draco::System
  filter TestComponent

  def tick(context)
    entities.each { |entity| entity.test_component.tested = true }
  end
end

class ObservedSystem < Draco::System
  filter TestComponent

  def tick(context)
    entities.each { |entity| entity.test_component.tested = true }
  end
end

class TestEntity < Draco::Entity
  component TestComponent
end

class TestWorld < Draco::World
  include Draco::Events

  observe ObservedSystem
  observe ObservedSystem, component: AddedComponent, on: :add
  observe ObservedSystem, component: RemovedComponent, on: :remove
end

RSpec.describe Draco::Events do
  it "has a version number" do
    expect(Draco::Events::VERSION).not_to be nil
  end

  context "#dispatch" do
    subject { TestWorld.new }

    it "dispatches an event" do
      DispatchedSystem.any_instance.expects(:tick).once
      subject.dispatch(DispatchedSystem)
      subject.tick({})
    end

    it "dispatches an event with an entity" do
      entity = TestEntity.new
      subject.dispatch(DispatchedSystem, entity)
      subject.tick({})

      expect(entity.test_component.tested).to be_truthy
    end

    it "dispatches an event with multiple entities" do
      a = TestEntity.new
      b = TestEntity.new

      subject.dispatch(DispatchedSystem, [a, b])
      subject.tick({})

      expect(a.test_component.tested).to be_truthy
      expect(b.test_component.tested).to be_truthy
    end

    it "bundles up system dispatches" do
      a = TestEntity.new
      b = TestEntity.new

      DispatchedSystem.any_instance.expects(:tick).once
      subject.dispatch(DispatchedSystem, a)
      subject.dispatch(DispatchedSystem, [b])
      subject.tick({})
    end
  end

  context ".observe" do
    subject { TestWorld.new }

    it "dispatches the system when an entity with the component is added" do
      entity = TestEntity.new
      subject.entities << entity
      subject.tick({})

      expect(entity.test_component.tested).to be_truthy
    end

    it "dispatches the system when the component is added" do
      entity = Draco::Entity.new
      subject.entities << entity
      entity.components << TestComponent.new
      subject.tick({})

      expect(entity.test_component.tested).to be_truthy
    end
    
    it "dispatches the system when the non-filtered component is added" do
      ObservedSystem.any_instance.expects(:tick)

      entity = TestEntity.new
      subject.entities << entity
      entity.components << AddedComponent.new
      subject.tick({})
    end

    it "dispatches the system when the component is removed" do
      entity = TestEntity.new
      entity.components << RemovedComponent.new
      subject.entities << entity
      entity.components.delete(entity.removed_component)

      subject.tick({})

      expect(entity.test_component.tested).to be_truthy
    end
  end
end
