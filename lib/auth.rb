require 'jwt'

class Auth
  ALGORITHM = 'HS256'.freeze
  AUTH_SECRET = ENV['AUTH_SECRET']

  def self.issue(payload)
    JWT.encode(
      payload,
      AUTH_SECRET,
      ALGORITHM
    )
  end

  def self.decode(token)
    jwt_token = JWT.decode(token, 
                           AUTH_SECRET, 
                           true, 
                           algorithm: ALGORITHM)
    JWT::Token.new(jwt_token)
  rescue JWT::ExpiredSignature
    JWT::Token.new([{ expired: true }])
  rescue StandardError
    JWT::Token.new([{ invalid: true }])
  end
end