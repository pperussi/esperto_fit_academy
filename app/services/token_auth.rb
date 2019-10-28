# Token authentication
class TokenAuth
  
  class << self
    def token_present(coded_token)
      token_decoded = Auth.decode(coded_token)
      token_size = token_decoded.length
      decoded_payload = token_decoded[0]
      if token_size > 1
        decoded_correctly(decoded_payload)
        renew_payload(token_decoded)
      elsif token_size == 1
        decoded_incorrectly(decoded_payload[:expired])
      end

      # if token_size > 1
      #   renew_payload(token_decoded)
      # end
    end

    def decoded_correctly(token_decoded)
      raise StandardError, 'Authentication error, invalid payload.' if invalid_token_type?(token_decoded['token_type'])
      raise StandardError, 'Permission error, action unauthorized.' if token_decoded['request_type'] == 'password_recovery' &&
                                                                       !request.original_fullpath.index('/users/' + token_decoded['user_id'].to_s).zero?
    end

    def decoded_incorrectly(token_expired)
      raise StandardError, 'Authentication error, token has been expired.' unless token_expired

      raise StandardError, 'Authentication error, token is wrong on header Authentication' 
    end

    def renew_payload(token_decoded)
      renewed_payload = token_decoded[0]['exp']

      return if renewed_payload.blank?
      return unless renew_payload_required?(renewed_payload)
        
      renewed_payload = 4.hours.from_now.to_i
      response.headers['JWT-Token-Renewed'] = Auth.issue(renewed_payload)
    end

    def renew_payload_required?(exp)
      time_end = Time.zone.at(exp)
      time_start = time_end - 1.hour
      time_now = Time.now.to_i

      time_now >= time_start.to_i && time_now <= time_end.to_i
    end

    def auth_params
      params.require(:auth).permit(:email, :password)
    end

    def invalid_token_type?(token_type)
      token_type != 'client_a2'
    end
  end
end