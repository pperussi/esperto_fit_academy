class Api::V1::ApiController < ActionController::API 

  before_action :authenticate

  def create
    user = User.find_by(email: auth_params[:email])
    if user.authenticate(auth_params[:password])
      jwt = Auth.issue({user: user.id})
      render json: {jwt: jwt}
    end
  end

    def auth
      Auth.decode(token) 
    end

    def authenticate
        password = request.headers[:password]
        decoded_password = Auth.decode(password)
        render json: {error: "unauthorized"}, status: 401  unless decoded_password == ENV['PASSWORD']
    end

  private
    def auth_params
      params.require(:auth).permit(:email, :password)
    end
end