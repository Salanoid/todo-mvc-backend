module Resolvers
  class TodosResolver < Resolvers::BaseResolver
    def resolve(*args)
      Todo.all
    end
  end
end
