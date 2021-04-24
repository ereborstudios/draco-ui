class Tree < Draco::Component
  attribute :parent_id, default: nil
  attribute :children, default: []
end
