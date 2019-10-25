class Api::V1::ApiController < ActionController::API 

  # before_action :authenticate
  before_action :jwt_auth_validation


  # def create
  #   user = User.find_by(email: auth_params[:email])
  #   if user.authenticate(auth_params[:password])
  #     jwt = Auth.issue({user: user.id})
  #     render json: {jwt: jwt}
  #   end
  # end

  def jwt_auth_validation
    if request.headers['Token'].present?
      token_decoded = Auth.decode(request.headers['Token'])
      # byebug
      if token_decoded.length > 1
        # jwt has been successfully decoded
        if jwt_invalid_payload(token_decoded[0])
          render json: { error: 'Authentication error, invalid payload.' }, status: :unauthorized
          return;
        elsif !jwt_invalid_payload(token_decoded[0]) && token_decoded[0]['request_type'] == 'password_recovery'
          # password recovery token verification
          unless request.original_fullpath.index('/users/'+token_decoded[0]['user_id'].to_s) == 0
            render json: { error: 'Permission error, action unauthorized.' }, status: :unauthorized
            return;
          end
        end
      elsif token_decoded.length == 1
        # jwt hasn't been decoded
        if !token_decoded[0][:expired].nil? && token_decoded[0][:expired]
          render json: { error: 'Authentication error, token has been expired.' }, status: :unauthorized
          return;
        else
          render json: { error: 'Authentication error, token is wrong on header Authentication' }, status: :unauthorized
          return;
        end
      end

      # renew token
      if token_decoded.length>1
        renewed_payload = token_decoded[0]

        if renewed_payload['exp'].present?
          time_start = Time.at(renewed_payload['exp']) - 1.hours
          time_end = Time.at(renewed_payload['exp'])
          time_now = Time.now.to_i

          if time_now >= time_start.to_i && time_now <= time_end.to_i
            renewed_payload['exp'] = 4.hours.from_now.to_i
            response.headers['JWT-Token-Renewed'] = Auth.issue(renewed_payload)
          end
        end
      end
    else
      render json: { error: 'Authentication error, token is missing on header Authentication' }, status: :unauthorized
      return;
    end
  end

  def auth
    Auth.decode(token) 
  end

  # def authenticate
  #     password = request.headers[:password]
  #     decoded_password = Auth.decode(password)
  #     render json: {error: "unauthorized"}, status: 401  unless decoded_password == ENV['Token']
  # end

  private
    def auth_params
      params.require(:auth).permit(:email, :password)
    end

    def jwt_invalid_payload(payload)
      !payload['token_type'].present? || payload['token_type'].present? && payload['token_type'] != 'client_a2'
    end
end