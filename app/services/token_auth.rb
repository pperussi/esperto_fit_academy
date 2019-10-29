# Token authentication
class TokenAuth
  attr_reader :coded_token

  def initialize(coded_token)
    @coded_token = coded_token
  end

  def token_present
    if token_decoded.decoded?
      # byebug
      renew_token
    elsif token_decoded.invalid?
      raise StandardError, 'Authentication error, invalid payload.'
    elsif token_decoded.expired?
      raise StandardError, 'Authentication error, token has been expired.'
    else
      raise StandardError, 'Authentication error, token is wrong on header Authentication' 
    end
  end

  private

  def token_decoded
    @token_decoded ||= Auth.decode(coded_token)
  end

  def renew_token
    token_expiration = token_decoded.expiration

    return if token_expiration.blank?
    return unless token_decoded.renew_token_required?
  end
end