require 'jwt'

class Auth
  ALGORITHM = 'HS256'
  AUTH_SECRET = ENV['AUTH_SECRET']

  def self.issue(payload)
    JWT.encode(
      payload,
      AUTH_SECRET,
      ALGORITHM)
  end

  def self.decode(token)
    JWT.decode(token, 
    AUTH_SECRET, 
    true, 
    { algorithm: ALGORITHM })
  rescue JWT::ExpiredSignature
    [{ expired: true }]
  rescue
    [{ invalid: true }]
  end
end