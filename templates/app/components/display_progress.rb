class DisplayProgress < Draco::Component
  attribute :_value, default: 0
  attribute :value, default: ->() { 0 }
  attribute :max, default: 100
  attribute :progress_value_id, default: nil
  attribute :background, default: 'sprites/draco-ui/progress/background_01.png'
  attribute :fill, default: 'sprites/draco-ui/progress/background_03.png'
end
