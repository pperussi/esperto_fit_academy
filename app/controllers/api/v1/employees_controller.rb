module Api
  module V1
    class EmployeesController < Api::V1::ApiController
      def employee_auth
        if params[:email] && params[:password]
          user = Employee.find_by(email: params[:email])

          if user&.authenticate_employee(params[:password], user)
            jwt_token = generate_payload(user)
      
            render json: { token: jwt_token }, status: :ok
          else
            render json: { error: 'Wrong email or password, please try again.' }, status: :unauthorized
          end
        else
          render json: { error: 'Missing necessary params.' }, status: :unauthorized
        end
      end

      def generate_payload(user)
        payload = { user_id: user.id, token_type: 'client_a2', exp: 4.hours.from_now.to_i }
        Auth.issue(payload)
      end
    end
  end
end