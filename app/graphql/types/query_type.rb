# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :todos, [ Types::TodoType ], null: true, resolver: Resolvers::TodosResolver, description: "Todo Type"
  end
end
