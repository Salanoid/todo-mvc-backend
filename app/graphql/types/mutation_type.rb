# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_todo, Types::TodoType, mutation: Mutations::Todo::CreateTodoMutation, description: "Create todo mutation"
    field :update_todo, Types::TodoType, mutation: Mutations::Todo::UpdateTodoMutation, description: "Update todo mutation"
  end
end
