module Mutations
  module Todo
    class UpdateTodoMutation < ::Mutations::BaseMutation
      argument :id, ID, required: true
      argument :body, String, required: false
      argument :active, Boolean, required: false

      def resolve(*args)
        params = args.first.dup
        todo = ::Todo.find_by_id(params.delete(:id))
        todo&.update(args.first.dup)

        Mutations::ErrorHandlerMutation.validate!(todo)
        todo
      end
    end
  end
end
