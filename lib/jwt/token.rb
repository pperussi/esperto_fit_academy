module JWT
  class Token
    attr_reader :token

    def initialize(token)
      @token = token
    end

    def decoded?
      valid_token_type?
    end 

    def decoded_payload
      token[0]
    end

    def expiration
      decoded_payload['exp']
    end

    def renew_token_required?
      time_end = Time.zone.at(expiration)
      time_start = time_end - 1.hour
      time_now = Time.now.to_i
  
      time_now >= time_start.to_i && time_now <= time_end.to_i
    end

    def expired?
      decoded_payload[:expired]
    end

    def invalid?
      !decoded?
    end

    private

    def valid_token_type?
      decoded_payload['token_type'] == 'client_a2'
    end
  end
end