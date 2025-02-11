module Mutations
  class ErrorHandlerMutation
    class << self
      def validate!(results)
        if results.blank?
          raise GraphQL::ExecutionError, "Missing item"
        end

        if results.is_a?(Array)
          validation_errors =
            results.each.with_object([]) do |result, acc|
              acc << result.errors.full_messages.join(", ")
            end

          raise GraphQL::ExecutionError, validation_errors
        end

        if results.errors.present?
          raise GraphQL::ExecutionError, results.errors.full_messages.join(", ")
        end
      end
    end
  end
end
