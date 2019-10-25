class Api::V1::EmployeesController < Api::V1::ApiController
    def employee_auth
        if params[:email] && params[:password]
        user = Employee.find_by(email: params[:email])

        if user && user.authenticate_employee(params[:password], user)
            payload = {
            user_id: user.id, token_type: 'client_a2', exp: 4.hours.from_now.to_i,
            }
            jwt_token = Auth.issue(payload)

            render json: { token: jwt_token }, status: 200
        else
            render json: { error: 'Wrong email or password, please try again.' }, status: :unauthorized
        end
        else
        render json: { error: 'Missing necessary params.' }, status: :unauthorized
        end
    end


end