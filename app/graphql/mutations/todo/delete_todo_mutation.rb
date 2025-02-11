module Mutations
  module Todo
    class DeleteTodoMutation < ::Mutations::BaseMutation
      argument :id, ID, required: true

      def resolve(*args)
        params = args.first.dup
        todo = ::Todo.find_by_id(params.delete(:id))
        todo&.destroy

        Mutations::ErrorHandlerMutation.validate!(todo)
        todo
      end
    end
  end
end
