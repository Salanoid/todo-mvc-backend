module Mutations
  module Todo
    class CreateTodoMutation < ::Mutations::BaseMutation
      argument :body, String, required: true

      def resolve(*args)
        todo_params = args.first.dup
        create_todo_result = ::Todo.create(todo_params)

        handle_errors_for(create_todo_result)
        create_todo_result
      end

      private

      def handle_errors_for(create_todo_result)
        if create_todo_result.errors.present?
          raise GraphQL::ExecutionError, create_todo_result.errors.full_messages.join(", ")
        end
      end
    end
  end
end
