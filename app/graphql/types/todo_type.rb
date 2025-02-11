module Types
  class TodoType < Types::BaseObject
    description "Todo Type"

    field :id, ID, null: false, description: "ID of the todo"
    field :body, String, null: false, description: "Body field"
  end
end
