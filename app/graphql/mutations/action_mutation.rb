module Mutations
  class ActionMutation
    class << self
      AVAILABLE_ACTIONS = %i[create create! update update! destroy]

      def handle!(entity, action, params)
        return unless AVAILABLE_ACTIONS.include?(action)

        begin
          result =
            if action == :destroy || params.blank?
              entity.send(action)
            else
              entity.send(action, params)
            end

          (result.is_a?(TrueClass) || result.is_a?(FalseClass)) ? entity : result
        rescue ActiveRecord::RecordInvalid => error
          error.to_s
        rescue ActiveModel::UnknownAttributeError => error
          error.to_s
        end
      end
    end
  end
end
