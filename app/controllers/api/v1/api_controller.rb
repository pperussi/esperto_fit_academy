module Api
  module V1
    class ApiController < ActionController::API 
      before_action :jwt_auth_validation

      def jwt_auth_validation
        token = request.headers['Token']
        if token.present?
          TokenAuth.new(token).token_present
        else
          render json: { error: 'Authentication error, missing token.' }, status: :unauthorized
        end
      rescue StandardError => error
        render json: { error: error.message }, status: :unauthorized
      end

      def employee_auth
        email = params[:email]
        password = params[:password]
        if email && password
          user = Employee.find_by(email: email)

          render json: { error: 'Wrong email or password, please try again.' }, status: :unauthorized unless user.authenticate_employee(password, user)
        else
          render json: { error: 'Missing necessary params.' }, status: :unauthorized
        end
      end
    end
  end
end