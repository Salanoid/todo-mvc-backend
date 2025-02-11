module Types
  class TodoType < Types::BaseObject
    description "Todo Type"

    field :id, ID, null: false, description: "ID of the todo"
    field :body, String, null: true, description: "Body field"
    field :active, Boolean, null: true, description: "Active state field"
  end
end
