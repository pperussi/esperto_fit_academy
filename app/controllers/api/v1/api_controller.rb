module Api
  module V1
    class ApiController < ActionController::API 

      before_action :jwt_auth_validation

      def jwt_auth_validation
        if request.headers['Token'].present?
          TokenAuth.new(request.headers['Token']).token_present
        end
      rescue StandardError => e
        render json: { error: e.message }, status: :unauthorized
      end
    end
  end
end