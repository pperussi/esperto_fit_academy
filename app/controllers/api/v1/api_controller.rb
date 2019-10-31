module Api
  module V1
    class ApiController < ActionController::API 
      before_action :jwt_auth_validation
      skip_before_action :jwt_auth_validation, only: [:employee_auth]

      def jwt_auth_validation
        token = request.headers['Token']
        logger.tagged 'Auth' do
          logger.info "Token received: #{token}"
        end
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

          if user.authenticate_employee(password, user)
            render json: { token: generate_token(user) }, status: :ok
          else
            render json: { error: 'Wrong email or password, please try again.' }, status: :unauthorized
          end
        else
          render json: { error: 'Missing necessary params.' }, status: :unauthorized
        end
      end

      def generate_token(user)
        payload = { user_id: user.id, token_type: 'client_a3', exp: 4.hours.from_now.to_i }
        Auth.issue(payload)
      end
    end
  end
end