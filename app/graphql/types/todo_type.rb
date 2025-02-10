module Types
  class TodoType < Types::BaseObject
    field :body, String, null: true, description: "Content of todo"
  end
end
