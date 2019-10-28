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
    JWT.decode(token, 
               AUTH_SECRET, 
               true, 
               algorithm: ALGORITHM)
  rescue JWT::ExpiredSignature
    [{ expired: true }]
  rescue StandardError
    [{ invalid: true }]
  end
end