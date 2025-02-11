module Mutations
  module Todo
    class CreateTodoMutation < ::Mutations::BaseMutation
      argument :body, String, required: true

      def resolve(*args)
        todo_params = args.first.dup
        create_todo_result = ::Todo.create(todo_params)

        Mutations::ErrorHandlerMutation.validate!(create_todo_result)
        create_todo_result
      end
    end
  end
end
