require "draco"

class FirstComponent < Draco::Component
  attribute :test, default: false
end

class SecondComponent < Draco::Component
  attribute :test, default: false
end

class TestEntity < Draco::Entity
  include Draco::State

  state [FirstComponent, SecondComponent]
end

class TestEntityWithDefault < Draco::Entity
  include Draco::State

  state [FirstComponent, SecondComponent], default: SecondComponent.new(test: true)
end

RSpec.describe Draco::State do
  context "without default" do
    subject { TestEntity.new }

    it "defaults to the first component" do
      expect(subject.first_component).to be
    end

    it "does not add a StateChanged component" do
      expect(subject.components[:state_changed]).to be_nil
    end
  end

  context "with default" do
    subject { TestEntityWithDefault.new }

    it "applies the default" do
      expect(subject.second_component.test).to be_truthy
    end
  end

  context "when adding a different state component" do
    subject { TestEntity.new }

    it "applies the new component" do
      subject.components << SecondComponent.new

      expect(subject.second_component).to be
    end

    it "removes the old component" do
      subject.components << SecondComponent.new

      expect(subject.components[:first_component]).to be_nil
    end

    it "adds a state_changed component" do
      from = subject.first_component
      to = SecondComponent.new
      subject.components << to

      expect(subject.state_changed.to).to eq(to)
      expect(subject.state_changed.from).to eq(from)
      expect(subject.state_changed.at).to be
    end
  end

  context "when removing a state component" do
    subject { TestEntity.new }
    let(:component) { subject.first_component }

    it "raises an error" do
      expect { subject.components.delete(component) }.to raise_error(Draco::State::StateNotSetError)
    end
  end
end
